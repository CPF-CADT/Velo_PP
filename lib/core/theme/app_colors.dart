import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF00897B);
  static const Color secondary = Color(0xFFFF9800);
  static const Color background = Color(0xFFF5F7F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
  static const Color textPrimary = Color(0xFF1C2328);
  static const Color textSecondary = Color(0xFF5D6A71);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  static const Color success = Color(0xFF00D084);
  static const Color info = Color(0xFF1E88E5);
  static const Color warning = Color(0xFFFF9800);

  static const Color primaryLight = Color(0xFFE0F2F1);
  static const Color primarySoft = Color(0xFFF2F7F7);
  static const Color primaryMuted = Color(0xFFF8FAFA);
  static const Color darkSurface = Color(0xFF2D2D2D);

  static Color withAlpha(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
