/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'EcoTrack';
  static const String appDisplayName = 'EcoTrack';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyThemeMode = 'theme_mode';
  static const String keyColorPalette = 'color_palette';
  static const String keyUserId = 'user_id';
  static const String keyIsDemoMode = 'is_demo_mode';

  // Carbon Footprint Constants (kg CO2 per unit)
  static const double carEmissionPerKm = 0.21; // kg CO2 per km
  static const double busEmissionPerKm = 0.089; // kg CO2 per km
  static const double trainEmissionPerKm = 0.014; // kg CO2 per km
  static const double planeEmissionPerKm = 0.255; // kg CO2 per km
  static const double electricityEmissionPerKwh = 0.5; // kg CO2 per kWh (varies by region)
  static const double meatEmissionPerKg = 27.0; // kg CO2 per kg
  static const double dairyEmissionPerKg = 3.2; // kg CO2 per kg
  static const double wasteEmissionPerKg = 0.5; // kg CO2 per kg

  // Eco Rating Levels
  static const List<EcoLevel> ecoLevels = [
    EcoLevel(name: 'Seed', minPoints: 0, maxPoints: 100),
    EcoLevel(name: 'Sprout', minPoints: 101, maxPoints: 300),
    EcoLevel(name: 'Sapling', minPoints: 301, maxPoints: 600),
    EcoLevel(name: 'Tree', minPoints: 601, maxPoints: 1000),
    EcoLevel(name: 'Forest', minPoints: 1001, maxPoints: 2000),
    EcoLevel(name: 'Ecosystem', minPoints: 2001, maxPoints: 999999),
  ];

  // Challenge Points
  static const int challengeCompletePoints = 50;
  static const int calculatorUsePoints = 10;
  static const int recyclingPointVisitPoints = 25;

  // Map Constants
  static const double defaultMapZoom = 13.0;
  static const double maxMapZoom = 18.0;
  static const double minMapZoom = 10.0;
  static const int maxRecyclingPoints = 50; // Max points to load on map

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // API Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
}

/// Eco rating level model
class EcoLevel {
  final String name;
  final int minPoints;
  final int maxPoints;

  const EcoLevel({
    required this.name,
    required this.minPoints,
    required this.maxPoints,
  });

  /// Get current level based on points
  static EcoLevel getLevelForPoints(int points) {
    for (final level in AppConstants.ecoLevels.reversed) {
      if (points >= level.minPoints) {
        return level;
      }
    }
    return AppConstants.ecoLevels.first;
  }

  /// Get progress percentage within current level
  static double getProgressForPoints(int points) {
    final level = getLevelForPoints(points);
    final range = level.maxPoints - level.minPoints;
    final progress = points - level.minPoints;
    return (progress / range).clamp(0.0, 1.0);
  }
}


