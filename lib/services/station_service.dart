import 'package:latlong2/latlong.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/l10n/app_localizations.dart';

abstract class StationGeographyService {
  const StationGeographyService();

  List<Station> generateStations(LatLng userLocation, AppLocalizations loc);
}

class MockStationGeographyService implements StationGeographyService {
  const MockStationGeographyService();

  @override
  List<Station> generateStations(LatLng userLocation, AppLocalizations loc) {
    return [
      Station(
        id: 'st_01',
        name: 'Eden Garden Station',
        location: LatLng(
          userLocation.latitude + 0.00045,
          userLocation.longitude,
        ),
        capacity: 12,
        bikesAvailable: 4,
        address: 'Eden Garden',
      ),
      Station(
        id: 'st_02',
        name: 'Central Market Station',
        location: LatLng(
          userLocation.latitude + 0.003,
          userLocation.longitude + 0.002,
        ),
        capacity: 16,
        bikesAvailable: 7,
        address: 'Phsar Thmei',
      ),
      Station(
        id: 'st_03',
        name: 'Riverside Station',
        location: LatLng(
          userLocation.latitude + 0.001,
          userLocation.longitude - 0.004,
        ),
        capacity: 10,
        bikesAvailable: 3,
        address: 'Sisowath Quay',
      ),
      Station(
        id: 'st_04',
        name: 'University Station',
        location: LatLng(
          userLocation.latitude - 0.004,
          userLocation.longitude - 0.002,
        ),
        capacity: 14,
        bikesAvailable: 6,
        address: 'Russian Blvd',
      ),
      Station(
        id: 'st_05',
        name: 'Night Market Station',
        location: LatLng(
          userLocation.latitude - 0.001,
          userLocation.longitude + 0.005,
        ),
        capacity: 8,
        bikesAvailable: 2,
        address: 'Night Market',
      ),
    ];
  }
}

class RealStationGeographyService implements StationGeographyService {
  const RealStationGeographyService();

  @override
  List<Station> generateStations(LatLng userLocation, AppLocalizations loc) {
    return [
      Station(
        id: 'st_01',
        name: 'Eden Garden Station',
        location: const LatLng(11.5622, 104.9152),
        capacity: 12,
        bikesAvailable: 4,
        address: 'Eden Garden',
      ),
      Station(
        id: 'st_02',
        name: 'Central Market Station',
        location: const LatLng(11.5695, 104.9210),
        capacity: 16,
        bikesAvailable: 7,
        address: 'Phsar Thmei',
      ),
      Station(
        id: 'st_03',
        name: 'Riverside Station',
        location: const LatLng(11.5735, 104.9292),
        capacity: 10,
        bikesAvailable: 3,
        address: 'Sisowath Quay',
      ),
      Station(
        id: 'st_04',
        name: 'University Station',
        location: const LatLng(11.5529, 104.9166),
        capacity: 14,
        bikesAvailable: 6,
        address: 'Russian Blvd',
      ),
      Station(
        id: 'st_05',
        name: 'Night Market Station',
        location: const LatLng(11.5754, 104.9263),
        capacity: 8,
        bikesAvailable: 2,
        address: 'Night Market',
      ),
    ];
  }
}

class StationService {
  /// Filter stations by search query
  static List<Station> filterStations(List<Station> stations, String query) {
    if (query.isEmpty) return stations;
    return stations
        .where(
          (station) =>
              station.name.toLowerCase().contains(query.toLowerCase()) ||
              station.address.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
