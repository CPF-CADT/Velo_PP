import 'package:latlong2/latlong.dart';
import '../core/constants/station_model.dart';
import '../l10n/app_localizations.dart';

class StationService {
  /// Generate mock stations around user location
  static List<Station> generateStations(
    LatLng userLocation,
    AppLocalizations loc,
  ) {
    return [
      Station(
        name: loc.get('station05'),
        location: LatLng(
          userLocation.latitude - 0.002,
          userLocation.longitude + 0.003,
        ),
        bikes: 8,
        address: loc.get('greenpark'),
      ),
      Station(
        name: loc.get('station08'),
        location: LatLng(
          userLocation.latitude + 0.003,
          userLocation.longitude + 0.002,
        ),
        bikes: 12,
        address: loc.get('downtowncenter'),
      ),
      Station(
        name: loc.get('station04'),
        location: LatLng(
          userLocation.latitude + 0.001,
          userLocation.longitude - 0.004,
        ),
        bikes: 5,
        address: loc.get('mainstreet'),
      ),
      Station(
        name: loc.get('station13'),
        location: LatLng(
          userLocation.latitude - 0.004,
          userLocation.longitude - 0.002,
        ),
        bikes: 10,
        address: loc.get('westdistrict'),
      ),
      Station(
        name: loc.get('station10'),
        location: LatLng(
          userLocation.latitude - 0.001,
          userLocation.longitude + 0.005,
        ),
        bikes: 6,
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
