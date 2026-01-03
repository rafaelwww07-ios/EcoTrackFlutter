import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';
import 'core/utils/firestore_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
    
    // Initialize Firestore data on first launch
    await initializeFirestoreData();
  } catch (e) {
    print('⚠️  Firebase initialization failed: $e');
    print('   App will continue to work in demo mode');
    // App will continue to work in demo mode
  }
  
  runApp(const EcoTrackApp());
}
