import 'package:latlong2/latlong.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/l10n/app_localizations.dart';

abstract class StationGeographyService {
  const StationGeographyService();

  List<Station> generateStations(
    LatLng userLocation,
    List<Station> repositoryStations,
    AppLocalizations loc,
  );
}

class MockStationGeographyService implements StationGeographyService {
  const MockStationGeographyService();

  static const List<List<double>> _offsets = <List<double>>[
    <double>[0.00045, 0.0],
    <double>[0.003, 0.002],
    <double>[0.001, -0.004],
    <double>[-0.004, -0.002],
    <double>[-0.001, 0.005],
  ];

  @override
  List<Station> generateStations(
    LatLng userLocation,
    List<Station> repositoryStations,
    AppLocalizations loc,
  ) {
    if (repositoryStations.isEmpty) {
      return <Station>[];
    }

    return repositoryStations.asMap().entries.map((entry) {
      final index = entry.key;
      final station = entry.value;
      final offset = _offsets[index % _offsets.length];
      return station.copyWith(
        location: LatLng(
          userLocation.latitude + offset[0],
          userLocation.longitude + offset[1],
        ),
      );
    }).toList();
  }
}

class RealStationGeographyService implements StationGeographyService {
  const RealStationGeographyService();

  @override
  List<Station> generateStations(
    LatLng userLocation,
    List<Station> repositoryStations,
    AppLocalizations loc,
  ) {
    return repositoryStations;
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
