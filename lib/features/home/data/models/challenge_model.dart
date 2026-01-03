import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Challenge model
class ChallengeModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final int pointsReward;
  final ChallengeStatus status;
  final DateTime? completedAt;
  final DateTime? expiresAt;
  final String? icon;

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.pointsReward,
    this.status = ChallengeStatus.active,
    this.completedAt,
    this.expiresAt,
    this.icon,
  });

  /// Check if challenge is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if challenge is completed
  bool get isCompleted => status == ChallengeStatus.completed;

  /// Create from JSON (supports both Firestore Timestamp and ISO strings)
  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.parse(value);
      }
      return null;
    }

    return ChallengeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: ChallengeType.fromString(json['type'] as String),
      pointsReward: (json['pointsReward'] as num?)?.toInt() ?? 0,
      status: ChallengeStatus.fromString(json['status'] as String? ?? 'active'),
      completedAt: parseDateTime(json['completedAt']),
      expiresAt: parseDateTime(json['expiresAt']),
      icon: json['icon'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'pointsReward': pointsReward,
      'status': status.toString().split('.').last,
      'completedAt': completedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'icon': icon,
    };
  }

  /// Create copy with updated fields
  ChallengeModel copyWith({
    String? id,
    String? title,
    String? description,
    ChallengeType? type,
    int? pointsReward,
    ChallengeStatus? status,
    DateTime? completedAt,
    DateTime? expiresAt,
    String? icon,
  }) {
    return ChallengeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      pointsReward: pointsReward ?? this.pointsReward,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        pointsReward,
        status,
        completedAt,
        expiresAt,
        icon,
      ];
}

/// Challenge type enum
enum ChallengeType {
  daily,
  weekly,
  monthly,
  special;

  static ChallengeType fromString(String value) {
    return ChallengeType.values.firstWhere(
      (e) => e.toString().split('.').last == value.toLowerCase(),
      orElse: () => ChallengeType.daily,
    );
  }
}

/// Challenge status enum
enum ChallengeStatus {
  active,
  completed,
  expired;

  static ChallengeStatus fromString(String value) {
    return ChallengeStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value.toLowerCase(),
      orElse: () => ChallengeStatus.active,
    );
  }
}

