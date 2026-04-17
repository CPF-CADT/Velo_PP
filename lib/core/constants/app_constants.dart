import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppConstants {
  // Map
  static const double initialMapZoom = 16.0;
  static const double minMapZoom = 12.0;
  static const double maxMapZoom = 19.0;
  static const String mapTileUrl =
      'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png';
  static const List<String> mapSubdomains = ['a', 'b', 'c'];

  // Localization
  static const Locale defaultLocale = Locale('km');
  static const List<Locale> supportedLocales = [Locale('en'), Locale('km')];
  static const String khmerFontFamily = 'NotoSansKhmer';
  static const String latinFontFamily = 'Roboto';

  // Colors
  static const Color primaryColor = AppColors.primary;
  static const Color accentColor = AppColors.secondary;
  static const Color errorColor = AppColors.error;

  // Distances for station offset
  static const double stationOffsetLat1 = 0.002;
  static const double stationOffsetLon1 = 0.003;
  static const double stationOffsetLat2 = 0.003;
  static const double stationOffsetLon2 = 0.002;
  static const double stationOffsetLat3 = 0.001;
  static const double stationOffsetLon3 = 0.004;
  static const double stationOffsetLat4 = 0.004;
  static const double stationOffsetLon4 = 0.002;
  static const double stationOffsetLat5 = 0.001;
  static const double stationOffsetLon5 = 0.005;
}

class TabIndex {
  static const int map = 0;
  static const int passes = 1;
  static const int rides = 2;
}
