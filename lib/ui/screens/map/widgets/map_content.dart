import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide DistanceCalculator;
import 'package:provider/provider.dart';
import 'package:velo_pp/core/constants/app_constants.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/services/location_service.dart';
import 'package:velo_pp/services/station_service.dart';
import 'package:velo_pp/ui/screens/map/view_model/map_view_model.dart';
import 'package:velo_pp/ui/widgets/control_button.dart';
import 'package:velo_pp/ui/screens/map/widgets/station_modal.dart';
import 'package:velo_pp/ui/screens/map/widgets/stations_bottom_sheet.dart';
import 'package:velo_pp/ui/screens/map/widgets/map_search_overlay.dart';
import 'package:velo_pp/core/utils/distance_calculator.dart';

class MapContent extends StatefulWidget {
  final VoidCallback onProfileTap;

  const MapContent({super.key, required this.onProfileTap});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  late MapController mapController;
  LatLng? userLocation;
  String? errorMessage;
  Station? selectedStation;
  String searchText = '';
  List<Station> nearbyMockStations = const [];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      final isLocationEnabled =
          await LocationService.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        _setError('locationError');
        return;
      }

      final permission = await LocationService.requestLocationPermission();
      if (LocationService.isPermissionDenied(permission)) {
        _setError('permissionError');
        return;
      }

      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        _loadStations(location);
      }
    } catch (e) {
      _setError('genericError');
    }
  }

  void _setError(String key) {
    setState(() {
      errorMessage = AppLocalizations.of(context).get(key);
    });
  }

  void _loadStations(LatLng location) {
    final viewModel = context.read<MapViewModel>();
    final loc = AppLocalizations.of(context);
    setState(() {
      userLocation = location;
      errorMessage = null;
      nearbyMockStations = StationService.generateStations(location, loc);
    });
    viewModel.loadStations();
  }

  List<Station> _getFilteredStations(List<Station> stations) {
    final availableStations = stations
        .where((station) => station.bikesAvailable > 0)
        .toList();

    return StationService.filterStations(availableStations, searchText);
  }

  void _showStationsBottomSheet(List<Station> stations) {
    final viewModel = context.read<MapViewModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => StationsBottomSheet(
        stations: _getFilteredStations(stations),
        selectedStation: selectedStation,
        userLocation: userLocation!,
        availableSlotsByStation: viewModel.getAvailableSlotsMap(),
        onStationSelected: (station) {
          setState(() {
            selectedStation = station;
          });
          mapController.move(station.location, 17);
          Navigator.pop(context);
          _showStationOverlay(station);
        },
      ),
    );
  }

  void _showStationModal(Station station) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          StationModal(station: station, userLocation: userLocation!),
    );
  }

  void _showStationOverlay(Station station) {
    final loc = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${station.name} • ${station.bikes} ${loc.get('bikes')}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final viewModel = context.watch<MapViewModel>();
    final stations = nearbyMockStations.isNotEmpty
        ? nearbyMockStations
        : (viewModel.stations.data ?? []);

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 50, color: Colors.red),
            const SizedBox(height: 12),
            Text(errorMessage!, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text(loc.get('retry')),
            ),
          ],
        ),
      );
    }

    if (userLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        _buildMapView(stations),
        _buildMapControls(),
        _buildAvailableButton(stations),
        _buildSearchOverlay(),
      ],
    );
  }

  Widget _buildMapView(List<Station> stations) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: userLocation!,
        initialZoom: AppConstants.initialMapZoom,
        minZoom: AppConstants.minMapZoom,
        maxZoom: AppConstants.maxMapZoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: AppConstants.mapTileUrl,
          subdomains: AppConstants.mapSubdomains,
          userAgentPackageName: 'velo_pp',
          maxZoom: 19,
        ),
        MarkerLayer(markers: _buildMarkers(stations)),
      ],
    );
  }

  List<Marker> _buildMarkers(List<Station> stations) {
    final markers = [
      // User location
      Marker(
        point: userLocation!,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () {
            mapController.move(userLocation!, 16);
          },
          child: const Icon(Icons.my_location, color: Colors.blue, size: 35),
        ),
      ),
      // Stations
      ..._getFilteredStations(stations).map((station) {
        final isSelected = selectedStation?.name == station.name;
        final distance = CustomDistanceCalculator.calculateDistance(
          userLocation!,
          station.location,
        );
        final distanceKm = CustomDistanceCalculator.formatDistance(distance);

        return Marker(
          point: station.location,
          width: 64,
          height: 62,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedStation = station;
              });
              _showStationModal(station);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    '$distanceKm km',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Icon(
                  Icons.pedal_bike,
                  color: isSelected ? Colors.orange : Colors.teal,
                  size: 35,
                ),
              ],
            ),
          ),
        );
      }),
    ];
    return markers;
  }

  Widget _buildMapControls() {
    return Positioned(
      right: 12,
      bottom: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ControlButton(
            icon: Icons.add,
            onPressed: () {
              mapController.move(
                mapController.camera.center,
                mapController.camera.zoom + 1,
              );
            },
          ),
          const SizedBox(height: 8),
          ControlButton(
            icon: Icons.remove,
            onPressed: () {
              mapController.move(
                mapController.camera.center,
                mapController.camera.zoom - 1,
              );
            },
          ),
          const SizedBox(height: 8),
          ControlButton(
            icon: Icons.my_location,
            onPressed: () {
              mapController.move(userLocation!, 16);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableButton(List<Station> stations) {
    final loc = AppLocalizations.of(context);

    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        onTap: () => _showStationsBottomSheet(stations),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pedal_bike, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                loc.get('available'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchOverlay() {
    return MapSearchOverlay(
      onProfileTap: widget.onProfileTap,
      onSearchChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
    );
  }
}
