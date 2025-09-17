import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

// Base colors extracted from the provided dark-mode screenshot
const Color _darkScaffold = Color(0xFF0F1824); // deep blue/black background
const Color _darkCard = Color(0xFF1A2532); // table/card rows background
const Color _darkBorder = Color(0xFF2B394A);
const Color _accentBlue = Colors.blueAccent;
const Color _successGreen = Color(0xFF2ECC71);
const Color _warningOrange = Color(0xFFF1A23B);
const Color _dangerRed = Color(0xFFE55353);

TextTheme _textTheme(Color onBg) => TextTheme(
      displayLarge: GoogleFonts.montserrat(fontSize: 15, color: onBg),
      labelLarge: GoogleFonts.montserrat(fontSize: 18, color: onBg),
      displayMedium: GoogleFonts.montserrat(fontSize: 15, color: onBg.withOpacity(0.9)),
      labelSmall: GoogleFonts.montserrat(fontSize: 13, color: onBg.withOpacity(0.9)),
      displaySmall: GoogleFonts.montserrat(fontSize: 11, color: onBg.withOpacity(0.8)),
      labelMedium: GoogleFonts.montserrat(fontSize: 16, color: onBg),
      titleSmall: GoogleFonts.montserrat(fontSize: 10, color: onBg.withOpacity(0.7)),
    );

final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: _accentBlue,
    surface: Colors.white,
    background: Color(0xFFFCFCFC),
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
  iconTheme: IconThemeData(color: Colors.grey[700]!),
  scaffoldBackgroundColor: const Color(0xFFFCFCFC),
  appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFFCFCFC), elevation: 0),
  cardColor: Colors.white,
  dividerColor: Colors.grey[300],
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey[300]!)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey[300]!)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey[300]!)),
  ),
  textTheme: _textTheme(Colors.black),
  dataTableTheme: DataTableThemeData(
    headingRowColor: MaterialStateProperty.all(Colors.grey[200]), // gris très léger
    dataRowColor: MaterialStateProperty.all(Colors.white),
    dividerThickness: 0,
    headingTextStyle: GoogleFonts.montserrat(color: Colors.grey, fontSize: 11),
    dataTextStyle: GoogleFonts.montserrat(color: Colors.black87, fontSize: 13),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.PRIMARY_BLUE_COLOR,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: _darkScaffold,
  colorScheme: const ColorScheme.dark(
    primary: _accentBlue,
    secondary: _accentBlue,
    surface: _darkCard,
    background: _darkScaffold,
    onBackground: Colors.white,
    onSurface: Colors.white,
    error: _dangerRed,
  ),
  appBarTheme: const AppBarTheme(backgroundColor: _darkScaffold, elevation: 0),
  cardColor: _darkCard,
  dividerColor: _darkBorder,
  textTheme: _textTheme(Colors.white),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _darkCard,
    hintStyle: GoogleFonts.montserrat(color: Colors.white70, fontSize: 13),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _darkBorder)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _darkBorder)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _accentBlue)),
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  dataTableTheme: DataTableThemeData(
    // headingRowColor: MaterialStateProperty.all(_darkCard.withOpacity(0.7)),
    dataRowColor: MaterialStateProperty.resolveWith((states) => _darkCard),
    dividerThickness: 0,
    headingTextStyle: GoogleFonts.montserrat(color: Colors.grey, fontWeight: FontWeight.w600),
    dataTextStyle: GoogleFonts.montserrat(color: Colors.white.withOpacity(0.95), fontSize: 13),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(Colors.black),
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) return Colors.white;
      return Colors.white70;
    }),
    side: const BorderSide(color: Colors.white70, width: 1.2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: _darkCard,
    selectedColor: _accentBlue.withOpacity(0.15),
    labelStyle: GoogleFonts.montserrat(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.PRIMARY_BLUE_COLOR,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
  ),
  extensions: <ThemeExtension<dynamic>>[
    _PillColors(
      success: _successGreen,
      warning: _warningOrange,
      danger: _dangerRed,
    ),
  ],
);

class _PillColors extends ThemeExtension<_PillColors> {
  final Color success;
  final Color warning;
  final Color danger;
  const _PillColors({required this.success, required this.warning, required this.danger});

  @override
  _PillColors copyWith({Color? success, Color? warning, Color? danger}) =>
      _PillColors(success: success ?? this.success, warning: warning ?? this.warning, danger: danger ?? this.danger);

  @override
  _PillColors lerp(ThemeExtension<_PillColors>? other, double t) {
    if (other is! _PillColors) return this;
    return _PillColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}
