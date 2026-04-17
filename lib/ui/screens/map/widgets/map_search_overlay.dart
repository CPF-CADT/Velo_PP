import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:velo_pp/core/utils/distance_calculator.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';
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
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.r14),
        onTap: () {
          _searchController.text = station.name;
          widget.onSearchChanged(station.name);
          widget.onStationSelected(station);
          _searchFocusNode.unfocus();
        },
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.primaryMuted,
            borderRadius: BorderRadius.circular(AppSpacing.r14),
            border: Border.all(
              color: AppColors.withAlpha(AppColors.primary, 0.1),
            ),
          ),
          padding: AppSpacing.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s10,
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.s34,
                height: AppSpacing.s34,
                decoration: BoxDecoration(
                  color: AppColors.withAlpha(AppColors.primary, 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pedal_bike,
                  size: AppSpacing.s18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.s10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      station.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${station.bikesAvailable} ${loc.get('bikesAvailable')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (distance != null)
                Container(
                  padding: AppSpacing.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.pill),
                    border: Border.all(
                      color: AppColors.withAlpha(AppColors.black, 0.15),
                    ),
                  ),
                  child: Text(
                    _formatDistance(loc, distance),
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
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
          margin: AppSpacing.all(AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Profile Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: AppSpacing.only(left: AppSpacing.s12),
                    child: Text(
                      loc.get('appTitle'),
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(AppSpacing.r20),
                    onTap: widget.onProfileTap,
                    child: const CircleAvatar(
                      radius: AppSpacing.s18,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: AppSpacing.s18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s12),
              // Search Bar
              Padding(
                padding: AppSpacing.symmetric(horizontal: 0),
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
                  constraints: const BoxConstraints(maxHeight: AppSpacing.s300),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppSpacing.r16),
                      bottomRight: Radius.circular(AppSpacing.r16),
                    ),
                    border: Border.all(
                      color: AppColors.withAlpha(AppColors.primary, 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.withAlpha(AppColors.black, 0.1),
                        blurRadius: AppSpacing.s18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: AppSpacing.fromLTRB(
                          AppSpacing.s14,
                          AppSpacing.s12,
                          AppSpacing.s14,
                          AppSpacing.s10,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppSpacing.r16),
                            topRight: Radius.circular(AppSpacing.r16),
                          ),
                        ),
                        child: Text(
                          '${widget.stations.length} ${loc.get('station')}',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: widget.stations.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: AppSpacing.all(AppSpacing.md),
                                  child: Text(
                                    loc.get('noStationsAvailable'),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: AppSpacing.all(AppSpacing.s10),
                                itemCount: widget.stations.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: AppSpacing.sm),
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
