import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _fundaOrange = Color(0xFFFF9900);

  static final ThemeData light = _build(
    ColorScheme.fromSeed(seedColor: _fundaOrange).copyWith(
      surface: const Color(0xFFFFF8F5),
      onSurface: const Color(0xFF211A14),
      onSurfaceVariant: const Color(0xFF51453A),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFFFF1E7),
      surfaceContainer: const Color(0xFFFAEBE0),
      surfaceContainerHigh: const Color(0xFFF4E6DB),
      surfaceContainerHighest: const Color(0xFFEFE0D5),
      primary: const Color(0xFF855318),
      onPrimary: const Color(0xFFFFFFFF),
      primaryContainer: _fundaOrange,
      onPrimaryContainer: const Color(0xFF4A2800),
      secondary: const Color(0xFF725A42),
      tertiary: const Color(0xFF58633A),
      outlineVariant: const Color(0xFFD5C3B5),
    ),
  );

  static final ThemeData dark = _build(
    ColorScheme.fromSeed(
      seedColor: _fundaOrange,
      brightness: Brightness.dark,
    ).copyWith(
      surface: const Color(0xFF111316),
      onSurface: const Color(0xFFE2E2E6),
      onSurfaceVariant: const Color(0xFFDBC2AD),
      surfaceContainerLowest: const Color(0xFF0C0E11),
      surfaceContainerLow: const Color(0xFF1A1C1F),
      surfaceContainer: const Color(0xFF1E2023),
      surfaceContainerHigh: const Color(0xFF282A2D),
      surfaceContainerHighest: const Color(0xFF333538),
      primary: const Color(0xFFFFC082),
      onPrimary: const Color(0xFF4A2800),
      primaryContainer: _fundaOrange,
      onPrimaryContainer: const Color(0xFF4A2800),
      secondary: const Color(0xFF4AE176),
      tertiary: const Color(0xFF54DDFC),
      outlineVariant: const Color(0xFF554434),
    ),
  );

  static ThemeData _build(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
