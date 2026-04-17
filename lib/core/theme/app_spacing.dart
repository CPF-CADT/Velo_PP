import 'package:flutter/widgets.dart';

class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  static const double xxs = 2;
  static const double s5 = 5;
  static const double s6 = 6;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s22 = 22;
  static const double s28 = 28;
  static const double s34 = 34;
  static const double s35 = 35;
  static const double s40 = 40;
  static const double s44 = 44;
  static const double s48 = 48;
  static const double s50 = 50;
  static const double s62 = 62;
  static const double s64 = 64;
  static const double s85 = 85;
  static const double s92 = 92;
  static const double s100 = 100;
  static const double s110 = 110;
  static const double s150 = 150;
  static const double s300 = 300;

  static const double r2 = 2;
  static const double r8 = 8;
  static const double r10 = 10;
  static const double r12 = 12;
  static const double r14 = 14;
  static const double r16 = 16;
  static const double r18 = 18;
  static const double r20 = 20;
  static const double r24 = 24;
  static const double r28 = 28;
  static const double r40 = 40;
  static const double pill = 999;

  static EdgeInsets all(double value) => EdgeInsets.all(value);
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  static EdgeInsets fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) => EdgeInsets.fromLTRB(left, top, right, bottom);
}
