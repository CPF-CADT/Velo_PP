import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class AppTheme {
  static ThemeData getBuildTheme(String languageCode) {
    return ThemeData(
      fontFamily: _getFontFamily(languageCode),
      useMaterial3: true,
      primaryColor: AppConstants.primaryColor,
      colorScheme: const ColorScheme.light(primary: AppConstants.primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static String _getFontFamily(String languageCode) {
    return languageCode == 'km'
        ? AppConstants.khmerFontFamily
        : AppConstants.latinFontFamily;
  }
}
