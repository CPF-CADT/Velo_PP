import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide DistanceCalculator;
import 'package:provider/provider.dart';
import 'package:velo_pp/core/constants/app_constants.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/services/location_service.dart';
import 'package:velo_pp/services/station_service.dart';
import 'package:velo_pp/ui/screens/map/view_model/map_view_model.dart';
import 'package:velo_pp/ui/screens/station/station_screen.dart';
import 'package:velo_pp/ui/widgets/control_button.dart';
import 'package:velo_pp/ui/screens/map/widgets/stations_bottom_sheet.dart';
import 'package:velo_pp/ui/screens/map/widgets/map_search_overlay.dart';
import 'package:velo_pp/ui/screens/map/widgets/station_modal.dart';
import 'package:velo_pp/core/utils/distance_calculator.dart';
import 'package:velo_pp/ui/states/ride_state.dart';

class MapContent extends StatefulWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onQuickReturnTap;
  final VoidCallback onOpenPassesTap;

  const MapContent({
    super.key,
    required this.onProfileTap,
    required this.onQuickReturnTap,
    required this.onOpenPassesTap,
  });

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  static const double _fastestClickMaxDistanceMeters = 100;

  late MapController mapController;
  LatLng? userLocation;
  String? errorMessage;
  Station? selectedStation;
  String searchText = '';
  bool _isNavigatingToSlotSelection = false;

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
    setState(() {
      userLocation = location;
      errorMessage = null;
    });
    viewModel.loadStations();
  }

  List<Station> _buildDisplayStations() {
    final location = userLocation;
    if (location == null) {
      return const <Station>[];
    }

    final viewModel = context.read<MapViewModel>();
    final stationGeographyService = context.read<StationGeographyService>();
    final loc = AppLocalizations.of(context);
    final repoStations = viewModel.stations.data ?? const <Station>[];

    return stationGeographyService.generateStations(
      location,
      repoStations,
      loc,
    );
  }

  List<Station> _getFilteredStations(List<Station> stations) {
    final viewModel = context.read<MapViewModel>();
    final availableStations = stations
        .where((station) => viewModel.shouldShowStation(station))
        .toList();

    return StationService.filterStations(availableStations, searchText);
  }

  List<Station> _getAvailableStationsSortedByDistance(List<Station> stations) {
    final filtered = _getFilteredStations(stations);
    if (userLocation == null) {
      return filtered;
    }

    filtered.sort((a, b) {
      final distanceA = CustomDistanceCalculator.calculateDistance(
        userLocation!,
        a.location,
      );
      final distanceB = CustomDistanceCalculator.calculateDistance(
        userLocation!,
        b.location,
      );
      return distanceA.compareTo(distanceB);
    });
    return filtered;
  }

  void _selectStationFromSearch(Station station) {
    setState(() {
      selectedStation = station;
      searchText = station.name;
    });
    mapController.move(station.location, 17);
    _openMockSlotSelection(station);
  }

  void _showStationsBottomSheet(List<Station> stations) {
    final viewModel = context.read<MapViewModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.r20),
          topRight: Radius.circular(AppSpacing.r20),
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
          _openMockSlotSelection(station);
        },
      ),
    );
  }

  Future<void> _openMockSlotSelection(Station station) async {
    if (_isNavigatingToSlotSelection || !mounted) return;

    setState(() {
      _isNavigatingToSlotSelection = true;
    });

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StationScreen(
          station: station,
          onOpenPassesTap: widget.onOpenPassesTap,
        ),
      ),
    );

    if (!mounted) return;
    await context.read<MapViewModel>().loadStations();

    if (!mounted) return;
    setState(() {
      _isNavigatingToSlotSelection = false;
    });
  }

  void _showStationInfoBottomSheet(Station station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.r20),
          topRight: Radius.circular(AppSpacing.r20),
        ),
      ),
      builder: (context) => StationModal(
        station: station,
        userLocation: userLocation!,
        onSelect: () => _openMockSlotSelection(station),
      ),
    );
  }

  String _formatDistanceForDisplay(double distanceMeters) {
    final loc = AppLocalizations.of(context);
    if (distanceMeters < 1000) {
      return '${distanceMeters.round()} ${loc.get('m')}';
    }
    return '${(distanceMeters / 1000).toStringAsFixed(2)} ${loc.get('km')}';
  }

  Station? _getNearestStation(List<Station> stations) {
    if (userLocation == null) return null;

    final availableStations = _getFilteredStations(stations);
    if (availableStations.isEmpty) return null;

    final from = userLocation!;
    return availableStations.reduce((nearest, current) {
      final nearestDistance = CustomDistanceCalculator.calculateDistance(
        from,
        nearest.location,
      );
      final currentDistance = CustomDistanceCalculator.calculateDistance(
        from,
        current.location,
      );
      return currentDistance < nearestDistance ? current : nearest;
    });
  }

  void _openNearestStationSlotSelection(List<Station> stations) {
    final loc = AppLocalizations.of(context);
    final nearestStation = _getNearestStation(stations);
    if (nearestStation == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.get('noStationsAvailable'))));
      return;
    }

    final distanceToNearest = CustomDistanceCalculator.calculateDistance(
      userLocation!,
      nearestStation.location,
    );

    if (distanceToNearest > _fastestClickMaxDistanceMeters) {
      final formattedDistance = _formatDistanceForDisplay(distanceToNearest);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${loc.get('tooFarForFastest')} ($formattedDistance). ${loc.get('fastestRangeHint')}',
          ),
        ),
      );
      return;
    }

    _openMockSlotSelection(nearestStation);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    context.watch<MapViewModel>();
    final stations = _buildDisplayStations();

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: AppSpacing.s50,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(errorMessage!, style: AppTextStyles.body),
            const SizedBox(height: AppSpacing.md),
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
        _buildActionButton(stations),
        _buildSearchOverlay(),
        _buildRideStatusBanner(),
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
          child: const Icon(
            Icons.my_location,
            color: AppColors.info,
            size: AppSpacing.s35,
          ),
        ),
      ),
      // Stations
      ..._getFilteredStations(stations).map((station) {
        final isSelected = selectedStation?.name == station.name;
        final distance = CustomDistanceCalculator.calculateDistance(
          userLocation!,
          station.location,
        );
        final distanceLabel = _formatDistanceForDisplay(distance);

        return Marker(
          point: station.location,
          width: 64,
          height: 62,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedStation = station;
              });
              _showStationInfoBottomSheet(station);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: AppSpacing.symmetric(
                    horizontal: AppSpacing.s6,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.r10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.withAlpha(AppColors.black, 0.12),
                        blurRadius: AppSpacing.xs,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    distanceLabel,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray900,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Icon(
                  Icons.pedal_bike,
                  color: isSelected ? AppColors.secondary : AppColors.primary,
                  size: AppSpacing.s35,
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
          const SizedBox(height: AppSpacing.sm),
          ControlButton(
            icon: Icons.remove,
            onPressed: () {
              mapController.move(
                mapController.camera.center,
                mapController.camera.zoom - 1,
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
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

  Widget _buildActionButton(List<Station> stations) {
    final loc = AppLocalizations.of(context);
    final activeBooking = context.watch<RideState>().booking;
    final isReturnMode =
        activeBooking != null && activeBooking.status.toLowerCase() == 'active';

    return Positioned(
      bottom: isReturnMode ? 92 : 20,
      right: 20,
      child: GestureDetector(
        onTap: isReturnMode
            ? widget.onQuickReturnTap
            : () => _openNearestStationSlotSelection(stations),
        onLongPress: isReturnMode
            ? null
            : () => _showStationsBottomSheet(stations),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.s12),
          ),
          padding: AppSpacing.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isReturnMode ? Icons.assignment_return : Icons.near_me,
                color: AppColors.white,
                size: AppSpacing.lg,
              ),
              const SizedBox(width: AppSpacing.s12),
              Text(
                isReturnMode ? 'Quick Return' : loc.get('quickSelect'),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchOverlay() {
    context.watch<MapViewModel>();
    final stations = _buildDisplayStations();

    return MapSearchOverlay(
      onProfileTap: widget.onProfileTap,
      stations: _getAvailableStationsSortedByDistance(stations),
      userLocation: userLocation,
      onStationSelected: _selectStationFromSearch,
      onSearchChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
    );
  }

  Widget _buildRideStatusBanner() {
    final activeBooking = context.watch<RideState>().booking;
    final hasActiveRide =
        activeBooking != null && activeBooking.status.toLowerCase() == 'active';
    if (!hasActiveRide) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 12,
      right: 12,
      bottom: 20,
      child: Container(
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.s14,
          vertical: AppSpacing.s10,
        ),
        decoration: BoxDecoration(
          color: AppColors.withAlpha(AppColors.secondary, 0.95),
          borderRadius: BorderRadius.circular(AppSpacing.s12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.pedal_bike,
              color: AppColors.white,
              size: AppSpacing.s18,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'You are currently holding a bike. Return it before booking another one.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
