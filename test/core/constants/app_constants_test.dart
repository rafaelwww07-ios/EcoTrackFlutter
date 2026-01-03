import 'package:flutter_test/flutter_test.dart';

import 'package:eco_track_flutter/core/constants/app_constants.dart';

void main() {
  group('EcoLevel', () {
    test('getLevelForPoints returns correct level', () {
      expect(EcoLevel.getLevelForPoints(0).name, 'Seed');
      expect(EcoLevel.getLevelForPoints(50).name, 'Seed');
      expect(EcoLevel.getLevelForPoints(150).name, 'Sprout');
      expect(EcoLevel.getLevelForPoints(500).name, 'Sapling');
      expect(EcoLevel.getLevelForPoints(800).name, 'Tree');
      expect(EcoLevel.getLevelForPoints(1500).name, 'Forest');
      expect(EcoLevel.getLevelForPoints(5000).name, 'Ecosystem');
    });

    test('getProgressForPoints returns correct progress', () {
      final progress = EcoLevel.getProgressForPoints(50);
      expect(progress, greaterThanOrEqualTo(0.0));
      expect(progress, lessThanOrEqualTo(1.0));
    });

    test('getProgressForPoints clamps to 0-1 range', () {
      final progress = EcoLevel.getProgressForPoints(10000);
      expect(progress, lessThanOrEqualTo(1.0));
    });
  });

  group('AppConstants', () {
    test('emission constants are positive', () {
      expect(AppConstants.carEmissionPerKm, greaterThan(0));
      expect(AppConstants.busEmissionPerKm, greaterThan(0));
      expect(AppConstants.trainEmissionPerKm, greaterThan(0));
      expect(AppConstants.planeEmissionPerKm, greaterThan(0));
      expect(AppConstants.electricityEmissionPerKwh, greaterThan(0));
      expect(AppConstants.meatEmissionPerKg, greaterThan(0));
      expect(AppConstants.dairyEmissionPerKg, greaterThan(0));
      expect(AppConstants.wasteEmissionPerKg, greaterThan(0));
    });

    test('ecoLevels list is not empty', () {
      expect(AppConstants.ecoLevels, isNotEmpty);
      expect(AppConstants.ecoLevels.length, greaterThan(0));
    });
  });
}


