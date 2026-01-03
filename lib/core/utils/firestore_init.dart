import 'package:cloud_firestore/cloud_firestore.dart';

/// Initialize Firestore with initial data (challenges)
/// This function checks if data already exists and only creates if needed
Future<void> initializeFirestoreData() async {
  try {
    final firestore = FirebaseFirestore.instance;

    // Check if challenges already exist
    try {
      final existingChallenges = await firestore
          .collection('challenges')
          .limit(1)
          .get();

      if (existingChallenges.docs.isNotEmpty) {
        print('✅ Firestore data already initialized');
        return; // Data already exists
      }
    } catch (e) {
      // Firestore might not be available (e.g., on web without config)
      print('⚠️  Could not check Firestore: $e');
      return;
    }

    print('📝 Initializing Firestore data...');

    // Challenges data
    final challenges = [
      {
        'title': 'Use Public Transport',
        'description': 'Use public transport instead of car for 3 days',
        'type': 'weekly',
        'pointsReward': 100,
        'status': 'active',
        'expiresAt': Timestamp.fromDate(DateTime(2024, 12, 31, 23, 59, 59)),
        'icon': '🚌',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Reduce Meat Consumption',
        'description': 'Have 5 vegetarian meals this week',
        'type': 'weekly',
        'pointsReward': 75,
        'status': 'active',
        'expiresAt': Timestamp.fromDate(DateTime(2024, 12, 31, 23, 59, 59)),
        'icon': '🥗',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Recycle Electronics',
        'description': 'Visit a recycling point for electronics',
        'type': 'monthly',
        'pointsReward': 150,
        'status': 'active',
        'expiresAt': Timestamp.fromDate(DateTime(2025, 1, 31, 23, 59, 59)),
        'icon': '💻',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Plant a Tree',
        'description': 'Plant a tree in your neighborhood',
        'type': 'monthly',
        'pointsReward': 200,
        'status': 'active',
        'expiresAt': Timestamp.fromDate(DateTime(2025, 2, 28, 23, 59, 59)),
        'icon': '🌳',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Use Reusable Water Bottle',
        'description': 'Use a reusable water bottle for 7 days',
        'type': 'weekly',
        'pointsReward': 50,
        'status': 'active',
        'expiresAt': Timestamp.fromDate(DateTime(2024, 12, 31, 23, 59, 59)),
        'icon': '💧',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    // Create challenges in a batch
    final batch = firestore.batch();
    for (final challengeData in challenges) {
      final challengeRef = firestore.collection('challenges').doc();
      batch.set(challengeRef, challengeData);
    }

    await batch.commit();
    print('✅ Created ${challenges.length} challenges in Firestore');
  } catch (e) {
    print('⚠️  Error initializing Firestore data: $e');
    // Don't throw - allow app to continue even if initialization fails
  }
}


