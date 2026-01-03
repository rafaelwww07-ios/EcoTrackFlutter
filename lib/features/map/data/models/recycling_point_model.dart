import 'package:equatable/equatable.dart';

/// Recycling point model
class RecyclingPointModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<WasteType> acceptedTypes;
  final String? phone;
  final String? website;
  final String? hours;
  final double? distance; // in km, calculated from user location

  const RecyclingPointModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.acceptedTypes,
    this.phone,
    this.website,
    this.hours,
    this.distance,
  });

  /// Create from JSON
  factory RecyclingPointModel.fromJson(Map<String, dynamic> json) {
    return RecyclingPointModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      acceptedTypes: (json['acceptedTypes'] as List<dynamic>)
          .map((e) => WasteType.fromString(e as String))
          .toList(),
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      hours: json['hours'] as String?,
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'acceptedTypes': acceptedTypes.map((e) => e.toString()).toList(),
      'phone': phone,
      'website': website,
      'hours': hours,
      'distance': distance,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        acceptedTypes,
        phone,
        website,
        hours,
        distance,
      ];
}

/// Waste type enum
enum WasteType {
  plastic,
  glass,
  paper,
  metal,
  electronics,
  batteries,
  organic,
  other;

  /// Create from string
  static WasteType fromString(String value) {
    return WasteType.values.firstWhere(
      (e) => e.toString().split('.').last == value.toLowerCase(),
      orElse: () => WasteType.other,
    );
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case WasteType.plastic:
        return 'Plastic';
      case WasteType.glass:
        return 'Glass';
      case WasteType.paper:
        return 'Paper';
      case WasteType.metal:
        return 'Metal';
      case WasteType.electronics:
        return 'Electronics';
      case WasteType.batteries:
        return 'Batteries';
      case WasteType.organic:
        return 'Organic';
      case WasteType.other:
        return 'Other';
    }
  }

  /// Get icon name
  String get iconName {
    switch (this) {
      case WasteType.plastic:
        return '♻️';
      case WasteType.glass:
        return '🍶';
      case WasteType.paper:
        return '📄';
      case WasteType.metal:
        return '🔩';
      case WasteType.electronics:
        return '💻';
      case WasteType.batteries:
        return '🔋';
      case WasteType.organic:
        return '🌱';
      case WasteType.other:
        return '📦';
    }
  }
}


