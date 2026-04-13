import 'package:latlong2/latlong.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/l10n/app_localizations.dart';

class StationService {
  /// Generate mock stations around user location
  static List<Station> generateStations(
    LatLng userLocation,
    AppLocalizations loc,
  ) {
    return [
      Station(
        id: 'st_05',
        name: loc.get('station05'),
        location: LatLng(
          userLocation.latitude - 0.002,
          userLocation.longitude + 0.003,
        ),
        capacity: 12,
        bikesAvailable: 8,
        address: loc.get('greenpark'),
      ),
      Station(
        id: 'st_08',
        name: loc.get('station08'),
        location: LatLng(
          userLocation.latitude + 0.003,
          userLocation.longitude + 0.002,
        ),
        capacity: 16,
        bikesAvailable: 12,
        address: loc.get('downtowncenter'),
      ),
      Station(
        id: 'st_04',
        name: loc.get('station04'),
        location: LatLng(
          userLocation.latitude + 0.001,
          userLocation.longitude - 0.004,
        ),
        capacity: 10,
        bikesAvailable: 5,
        address: loc.get('mainstreet'),
      ),
      Station(
        id: 'st_13',
        name: loc.get('station13'),
        location: LatLng(
          userLocation.latitude - 0.004,
          userLocation.longitude - 0.002,
        ),
        capacity: 14,
        bikesAvailable: 10,
        address: loc.get('westdistrict'),
      ),
      Station(
        id: 'st_10',
        name: loc.get('station10'),
        location: LatLng(
          userLocation.latitude - 0.001,
          userLocation.longitude + 0.005,
        ),
        capacity: 12,
        bikesAvailable: 6,
        address: loc.get('eastmarket'),
      ),
    ];
  }

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
