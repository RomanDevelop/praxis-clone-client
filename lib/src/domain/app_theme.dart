import 'package:flutter/material.dart';

/// Класс для управления темой приложения согласно SOLID (Single Responsibility Principle)
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF1A2639),
      primaryColor: const Color(0xFF3E4C5E),
      secondaryHeaderColor: Colors.cyan.shade300,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF1A1A1A),
      ),
    );
  }

  static Color get primaryBackground => const Color(0xFF1A2639);
  static Color get secondaryBackground => const Color(0xFF121212);
  static Color get primaryAccent => const Color(0xFF3E4C5E);
  static Color get accentColor => Colors.cyan;
}
