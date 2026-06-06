import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color primaryBlue = Color(0xFF1B84FF);
  static const Color ink = Color(0xFF071437);
  static const Color muted = Color(0xFF64748B);
  static const Color canvas = Color(0xFFF8FAFC);
  static const Color panel = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF17C653);
  static const Color warning = Color(0xFFF59E0B);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: success,
        surface: panel,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: panel,
        foregroundColor: ink,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: panel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: ink,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: ink,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: ink,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(color: muted, fontSize: 13),
        labelMedium: TextStyle(
          color: muted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
