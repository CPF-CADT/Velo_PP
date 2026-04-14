import 'dart:math';
import 'package:latlong2/latlong.dart';

class CustomDistanceCalculator {
  /// Calculate distance between two locations in meters using Haversine formula
  static double calculateDistance(LatLng userLocation, LatLng stationLocation) {
    const p = 0.017453292519943295;
    final a =
        0.5 -
        cos((stationLocation.latitude - userLocation.latitude) * p) / 2 +
        cos(userLocation.latitude * p) *
            cos(stationLocation.latitude * p) *
            (1 -
                cos((stationLocation.longitude - userLocation.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  /// Format distance in kilometers
  static String formatDistance(double distanceInMeters) {
    final km = distanceInMeters / 1000;
    return km.toStringAsFixed(2);
  }
}
