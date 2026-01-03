import 'package:flutter/material.dart';

/// Theme mode enum
enum AppThemeMode { light, dark, system }

/// Color palette enum
enum AppColorPalette { eco, minimalist, vibrant }

/// App theme configuration with multiple color palettes
class AppTheme {
  // Eco-friendly palette (default)
  static const Color ecoPrimary = Color(0xFF4CAF50);
  static const Color ecoSecondary = Color(0xFF81C784);
  static const Color ecoAccent = Color(0xFF66BB6A);
  static const Color ecoBackground = Color(0xFFF1F8F4);
  static const Color ecoSurface = Color(0xFFFFFFFF);
  static const Color ecoError = Color(0xFFE57373);
  static const Color ecoOnPrimary = Color(0xFFFFFFFF);
  static const Color ecoOnSecondary = Color(0xFFFFFFFF);
  static const Color ecoOnBackground = Color(0xFF1B5E20);
  static const Color ecoOnSurface = Color(0xFF212121);

  // Minimalist palette
  static const Color minPrimary = Color(0xFF212121);
  static const Color minSecondary = Color(0xFF424242);
  static const Color minAccent = Color(0xFF616161);
  static const Color minBackground = Color(0xFFFAFAFA);
  static const Color minSurface = Color(0xFFFFFFFF);
  static const Color minError = Color(0xFFD32F2F);
  static const Color minOnPrimary = Color(0xFFFFFFFF);
  static const Color minOnSecondary = Color(0xFFFFFFFF);
  static const Color minOnBackground = Color(0xFF212121);
  static const Color minOnSurface = Color(0xFF212121);

  // Vibrant palette
  static const Color vibPrimary = Color(0xFF00BCD4);
  static const Color vibSecondary = Color(0xFF00ACC1);
  static const Color vibAccent = Color(0xFFFF9800);
  static const Color vibBackground = Color(0xFFE0F7FA);
  static const Color vibSurface = Color(0xFFFFFFFF);
  static const Color vibError = Color(0xFFE91E63);
  static const Color vibOnPrimary = Color(0xFFFFFFFF);
  static const Color vibOnSecondary = Color(0xFFFFFFFF);
  static const Color vibOnBackground = Color(0xFF006064);
  static const Color vibOnSurface = Color(0xFF212121);

  /// Get light theme based on palette
  static ThemeData getLightTheme(AppColorPalette palette) {
    final colors = _getColors(palette);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        tertiary: colors['accent']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
      ),
      scaffoldBackgroundColor: colors['background'],
      appBarTheme: AppBarTheme(
        backgroundColor: colors['primary'],
        foregroundColor: colors['onPrimary'],
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: colors['surface'],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors['surface'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors['primary']!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors['primary']!.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors['primary']!, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
      ),
    );
  }

  /// Get dark theme based on palette
  static ThemeData getDarkTheme(AppColorPalette palette) {
    final colors = _getColors(palette);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        tertiary: colors['accent']!,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: const Color(0xFFE0E0E0),
        onBackground: const Color(0xFFE0E0E0),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['primary'],
        foregroundColor: colors['onPrimary'],
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors['primary']!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors['primary']!.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors['primary']!, width: 2),
        ),
      ),
    );
  }

  /// Get colors for specific palette
  static Map<String, Color> _getColors(AppColorPalette palette) {
    switch (palette) {
      case AppColorPalette.eco:
        return {
          'primary': ecoPrimary,
          'secondary': ecoSecondary,
          'accent': ecoAccent,
          'background': ecoBackground,
          'surface': ecoSurface,
          'error': ecoError,
          'onPrimary': ecoOnPrimary,
          'onSecondary': ecoOnSecondary,
          'onBackground': ecoOnBackground,
          'onSurface': ecoOnSurface,
        };
      case AppColorPalette.minimalist:
        return {
          'primary': minPrimary,
          'secondary': minSecondary,
          'accent': minAccent,
          'background': minBackground,
          'surface': minSurface,
          'error': minError,
          'onPrimary': minOnPrimary,
          'onSecondary': minOnSecondary,
          'onBackground': minOnBackground,
          'onSurface': minOnSurface,
        };
      case AppColorPalette.vibrant:
        return {
          'primary': vibPrimary,
          'secondary': vibSecondary,
          'accent': vibAccent,
          'background': vibBackground,
          'surface': vibSurface,
          'error': vibError,
          'onPrimary': vibOnPrimary,
          'onSecondary': vibOnSecondary,
          'onBackground': vibOnBackground,
          'onSurface': vibOnSurface,
        };
    }
  }
}

