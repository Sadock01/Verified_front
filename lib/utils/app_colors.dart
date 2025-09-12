import 'dart:ui';

class AppColors {
  static const Color PRIMARY_WHITE_LIGHT = Color(0xffffffff);
  static const Color PRIMARY_BLACK_DARK = Color(0xff1a1a1a);
  static const Color STATUS_SUCCES = Color.fromRGBO(3, 152, 85, 1);
  static const Color PRIMARY_BLUE_COLOR = Color(0xff033578);
  static const Color PRIMARY_BLACK2_COLOR = Color(0xFF1B263B);
  static const Color PRIMARY_BLACK3_COLOR = Color(0xFF212936);
  static const Color SECONDARY_BLUE_COLOR = Color.fromRGBO(21, 112, 239, 1);
  static const Color RED_COLOR = Color.fromRGBO(249, 112, 102, 1);

  static Color primaryForegroundColor(bool isDark) => isDark ? PRIMARY_WHITE_LIGHT : PRIMARY_BLACK_DARK;

  static Color primaryBackgroundColor(bool isDark) => isDark ? PRIMARY_BLACK_DARK : PRIMARY_WHITE_LIGHT;

  static Color primaryBlueColor(bool isDark) => PRIMARY_BLUE_COLOR;

  static Color secondaryBlueColor(bool isDark) => SECONDARY_BLUE_COLOR;

  static Color redColor(bool isDark) => RED_COLOR;
}
