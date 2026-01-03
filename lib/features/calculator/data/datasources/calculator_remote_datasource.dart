import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/carbon_footprint_model.dart';

/// Remote data source for carbon footprint calculations
class CalculatorRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save carbon footprint calculation to Firestore
  Future<void> saveCarbonFootprint(CarbonFootprintModel footprint) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to save calculations');
    }

    try {
      await _firestore
          .collection('carbonFootprints')
          .add({
        'userId': user.uid,
        'transportEmissions': footprint.transportEmissions,
        'energyEmissions': footprint.energyEmissions,
        'dietEmissions': footprint.dietEmissions,
        'wasteEmissions': footprint.wasteEmissions,
        'totalEmissions': footprint.totalEmissions,
        'calculatedAt': Timestamp.fromDate(footprint.calculatedAt),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save carbon footprint: ${e.toString()}');
    }
  }

  /// Get user's carbon footprint history
  Future<List<CarbonFootprintModel>> getUserFootprintHistory({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 30,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    try {
      Query query = _firestore
          .collection('carbonFootprints')
          .where('userId', isEqualTo: user.uid)
          .orderBy('calculatedAt', descending: true)
          .limit(limit);

      if (startDate != null) {
        query = query.where('calculatedAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }
      if (endDate != null) {
        query = query.where('calculatedAt',
            isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CarbonFootprintModel(
          transportEmissions: (data['transportEmissions'] as num).toDouble(),
          energyEmissions: (data['energyEmissions'] as num).toDouble(),
          dietEmissions: (data['dietEmissions'] as num).toDouble(),
          wasteEmissions: (data['wasteEmissions'] as num).toDouble(),
          calculatedAt: (data['calculatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get footprint history: ${e.toString()}');
    }
  }

  /// Get user's weekly statistics
  Future<Map<String, double>> getWeeklyStatistics() async {
    final user = _auth.currentUser;
    if (user == null) {
      return {};
    }

    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = now.add(Duration(days: 7 - now.weekday));

      final snapshot = await _firestore
          .collection('carbonFootprints')
          .where('userId', isEqualTo: user.uid)
          .where('calculatedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(weekStart))
          .where('calculatedAt',
              isLessThanOrEqualTo: Timestamp.fromDate(weekEnd))
          .get();

      final dailyEmissions = <String, double>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['calculatedAt'] as Timestamp).toDate();
        final dayKey = '${date.year}-${date.month}-${date.day}';
        dailyEmissions[dayKey] =
            (dailyEmissions[dayKey] ?? 0.0) + (data['totalEmissions'] as num).toDouble();
      }

      return dailyEmissions;
    } catch (e) {
      throw Exception('Failed to get weekly statistics: ${e.toString()}');
    }
  }
}


