import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  // Pour changer facilement de mode
  bool get isDark => themeMode == ThemeMode.dark;

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
