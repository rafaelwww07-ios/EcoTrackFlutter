import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Carbon footprint calculation model
class CarbonFootprintModel extends Equatable {
  final double transportEmissions; // kg CO2
  final double energyEmissions; // kg CO2
  final double dietEmissions; // kg CO2
  final double wasteEmissions; // kg CO2
  final DateTime calculatedAt;

  const CarbonFootprintModel({
    required this.transportEmissions,
    required this.energyEmissions,
    required this.dietEmissions,
    required this.wasteEmissions,
    required this.calculatedAt,
  });

  /// Total emissions in kg CO2
  double get totalEmissions =>
      transportEmissions + energyEmissions + dietEmissions + wasteEmissions;

  /// Total emissions in tons CO2
  double get totalEmissionsInTons => totalEmissions / 1000;

  /// Get emissions breakdown as percentage
  Map<String, double> get emissionsBreakdown {
    if (totalEmissions == 0) {
      return {
        'transport': 0.0,
        'energy': 0.0,
        'diet': 0.0,
        'waste': 0.0,
      };
    }
    return {
      'transport': (transportEmissions / totalEmissions) * 100,
      'energy': (energyEmissions / totalEmissions) * 100,
      'diet': (dietEmissions / totalEmissions) * 100,
      'waste': (wasteEmissions / totalEmissions) * 100,
    };
  }

  /// Create from JSON (supports both Firestore Timestamp and ISO strings)
  factory CarbonFootprintModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value == null) {
        return DateTime.now();
      }
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.parse(value);
      }
      return DateTime.now();
    }

    return CarbonFootprintModel(
      transportEmissions: (json['transportEmissions'] as num).toDouble(),
      energyEmissions: (json['energyEmissions'] as num).toDouble(),
      dietEmissions: (json['dietEmissions'] as num).toDouble(),
      wasteEmissions: (json['wasteEmissions'] as num).toDouble(),
      calculatedAt: parseDateTime(json['calculatedAt']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'transportEmissions': transportEmissions,
      'energyEmissions': energyEmissions,
      'dietEmissions': dietEmissions,
      'wasteEmissions': wasteEmissions,
      'calculatedAt': calculatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        transportEmissions,
        energyEmissions,
        dietEmissions,
        wasteEmissions,
        calculatedAt,
      ];
}

/// Calculator input model
class CalculatorInputModel extends Equatable {
  final double carKm;
  final double busKm;
  final double trainKm;
  final double planeKm;
  final double electricityKwh;
  final double meatKg;
  final double dairyKg;
  final double wasteKg;

  const CalculatorInputModel({
    this.carKm = 0,
    this.busKm = 0,
    this.trainKm = 0,
    this.planeKm = 0,
    this.electricityKwh = 0,
    this.meatKg = 0,
    this.dairyKg = 0,
    this.wasteKg = 0,
  });

  CalculatorInputModel copyWith({
    double? carKm,
    double? busKm,
    double? trainKm,
    double? planeKm,
    double? electricityKwh,
    double? meatKg,
    double? dairyKg,
    double? wasteKg,
  }) {
    return CalculatorInputModel(
      carKm: carKm ?? this.carKm,
      busKm: busKm ?? this.busKm,
      trainKm: trainKm ?? this.trainKm,
      planeKm: planeKm ?? this.planeKm,
      electricityKwh: electricityKwh ?? this.electricityKwh,
      meatKg: meatKg ?? this.meatKg,
      dairyKg: dairyKg ?? this.dairyKg,
      wasteKg: wasteKg ?? this.wasteKg,
    );
  }

  @override
  List<Object?> get props => [
        carKm,
        busKm,
        trainKm,
        planeKm,
        electricityKwh,
        meatKg,
        dairyKg,
        wasteKg,
      ];
}

