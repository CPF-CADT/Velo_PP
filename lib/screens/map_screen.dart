import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../l10n/app_localizations.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/station_model.dart';
import '../services/location_service.dart';
import '../services/station_service.dart';
import '../widgets/control_button.dart';
import '../widgets/station_modal.dart';
import '../widgets/stations_bottom_sheet.dart';
import '../widgets/search_bar.dart';

class MapScreen extends StatefulWidget {
  final String searchQuery;

  const MapScreen({super.key, required this.searchQuery});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController mapController;
  LatLng? userLocation;
  String? errorMessage;
  Station? selectedStation;
  List<Station> stations = [];
  String searchText = '';

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
      _setError('Error: $e');
    }
  }

  void _setError(String key) {
    setState(() {
      errorMessage = key == 'Error:'
          ? key
          : AppLocalizations.of(context).get(key);
    });
  }

  void _loadStations(LatLng location) {
    final loc = AppLocalizations.of(context);
    setState(() {
      userLocation = location;
      stations = StationService.generateStations(location, loc);
      errorMessage = null;
    });
  }

  List<Station> _getFilteredStations() {
    return StationService.filterStations(stations, searchText);
  }

  void _showStationsBottomSheet() {
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
        stations: _getFilteredStations(),
        selectedStation: selectedStation,
        userLocation: userLocation!,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${station.name} • ${station.bikes} bikes',
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
        _buildMapView(),
        _buildMapControls(),
        _buildAvailableButton(),
        _buildSearchBar(),
      ],
    );
  }

  Widget _buildMapView() {
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
        MarkerLayer(markers: _buildMarkers()),
      ],
    );
  }

  List<Marker> _buildMarkers() {
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
      ..._getFilteredStations().map((station) {
        final isSelected = selectedStation?.name == station.name;
        return Marker(
          point: station.location,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedStation = station;
              });
              _showStationModal(station);
            },
            child: Icon(
              Icons.pedal_bike,
              color: isSelected ? Colors.orange : Colors.teal,
              size: 35,
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

  Widget _buildAvailableButton() {
    final loc = AppLocalizations.of(context);

    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        onTap: _showStationsBottomSheet,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
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

  Widget _buildSearchBar() {
    final loc = AppLocalizations.of(context);

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: CustomSearchBar(
        hintText: loc.get('searchHint'),
        onChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
      ),
    );
  }
}
