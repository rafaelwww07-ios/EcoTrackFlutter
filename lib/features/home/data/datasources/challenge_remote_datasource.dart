import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/challenge_model.dart';

/// Remote data source for challenges
class ChallengeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get active challenges for user
  Future<List<ChallengeModel>> getActiveChallenges() async {
    try {
      // Get global challenges
      final globalSnapshot = await _firestore
          .collection('challenges')
          .where('status', isEqualTo: 'active')
          .get();

      final challenges = globalSnapshot.docs.map((doc) {
        final data = doc.data();
        return ChallengeModel.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();

      // Get user's challenge progress
      final user = _auth.currentUser;
      if (user != null) {
        final userChallengesSnapshot = await _firestore
            .collection('userChallenges')
            .where('userId', isEqualTo: user.uid)
            .get();

        final userChallengesMap = <String, Map<String, dynamic>>{};
        for (var doc in userChallengesSnapshot.docs) {
          final data = doc.data();
          userChallengesMap[data['challengeId'] as String] = data;
        }

        // Update challenges with user progress
        for (var i = 0; i < challenges.length; i++) {
          final challengeId = challenges[i].id;
          if (userChallengesMap.containsKey(challengeId)) {
            final userData = userChallengesMap[challengeId]!;
            if (userData['completed'] == true) {
              challenges[i] = challenges[i].copyWith(
                status: ChallengeStatus.completed,
                completedAt: (userData['completedAt'] as Timestamp?)?.toDate(),
              );
            }
          }
        }
      }

      return challenges;
    } catch (e) {
      throw Exception('Failed to get challenges: ${e.toString()}');
    }
  }

  /// Complete a challenge
  Future<void> completeChallenge(String challengeId, int pointsReward) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated');
    }

    try {
      final batch = _firestore.batch();

      // Update user challenge progress
      final userChallengeRef = _firestore
          .collection('userChallenges')
          .doc('${user.uid}_$challengeId');

      batch.set(userChallengeRef, {
        'userId': user.uid,
        'challengeId': challengeId,
        'completed': true,
        'completedAt': FieldValue.serverTimestamp(),
        'pointsEarned': pointsReward,
      }, SetOptions(merge: true));

      // Update user's eco points
      final userRef = _firestore.collection('users').doc(user.uid);
      batch.update(userRef, {
        'ecoPoints': FieldValue.increment(pointsReward),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to complete challenge: ${e.toString()}');
    }
  }
}


