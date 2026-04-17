import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:velo_pp/core/utils/distance_calculator.dart';
import 'package:velo_pp/model/station.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/search_bar.dart';

class MapSearchOverlay extends StatefulWidget {
  final VoidCallback onProfileTap;
  final Function(String) onSearchChanged;
  final List<Station> stations;
  final LatLng? userLocation;
  final Function(Station) onStationSelected;

  const MapSearchOverlay({
    super.key,
    required this.onProfileTap,
    required this.onSearchChanged,
    required this.stations,
    required this.userLocation,
    required this.onStationSelected,
  });

  @override
  State<MapSearchOverlay> createState() => _MapSearchOverlayState();
}

class _MapSearchOverlayState extends State<MapSearchOverlay> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _formatDistance(AppLocalizations loc, double distanceMeters) {
    if (distanceMeters < 1000) {
      return '${distanceMeters.round()} ${loc.get('m')}';
    }
    return '${(distanceMeters / 1000).toStringAsFixed(2)} ${loc.get('km')}';
  }

  Widget _buildStationResultItem(
    BuildContext context,
    AppLocalizations loc,
    Station station,
  ) {
    final distance = widget.userLocation == null
        ? null
        : CustomDistanceCalculator.calculateDistance(
            widget.userLocation!,
            station.location,
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          _searchController.text = station.name;
          widget.onSearchChanged(station.name);
          widget.onStationSelected(station);
          _searchFocusNode.unfocus();
        },
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x1A00897B)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0x1900897B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pedal_bike,
                  size: 18,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      station.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF1C2328),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${station.bikesAvailable} ${loc.get('bikesAvailable')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5D6A71),
                      ),
                    ),
                  ],
                ),
              ),
              if (distance != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0x26000000)),
                  ),
                  child: Text(
                    _formatDistance(loc, distance),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: Color(0xFF273238),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final showResultsPanel = _isSearchFocused;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Profile Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      loc.get('appTitle'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: widget.onProfileTap,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: CustomSearchBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: widget.onSearchChanged,
                  removeBottomRadius: showResultsPanel,
                  onFocusChanged: (isFocused) {
                    setState(() {
                      _isSearchFocused = isFocused;
                    });
                  },
                  hintText: loc.get('searchHint'),
                ),
              ),
              if (showResultsPanel) ...[
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: const Color(0x1400897B)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2F7F7),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          '${widget.stations.length} ${loc.get('station')}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF235A56),
                          ),
                        ),
                      ),
                      Expanded(
                        child: widget.stations.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    loc.get('noStationsAvailable'),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6A757C),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(10),
                                itemCount: widget.stations.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final station = widget.stations[index];
                                  return _buildStationResultItem(
                                    context,
                                    loc,
                                    station,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
