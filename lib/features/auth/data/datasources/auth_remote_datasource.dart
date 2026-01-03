import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/user_model.dart';

/// Remote data source for authentication
class AuthRemoteDataSource {
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  FirebaseFirestore? _firestore;
  
  bool get _isFirebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  FirebaseAuth get auth {
    if (!_isFirebaseAvailable) {
      throw Exception('Firebase is not initialized');
    }
    _auth ??= FirebaseAuth.instance;
    return _auth!;
  }
  
  GoogleSignIn get googleSignIn {
    _googleSignIn ??= GoogleSignIn(
      // Server client ID is optional, Firebase handles it automatically
      // But you can specify it if needed for web
      // serverClientId: 'YOUR_SERVER_CLIENT_ID',
    );
    return _googleSignIn!;
  }
  
  FirebaseFirestore get firestore {
    if (!_isFirebaseAvailable) {
      throw Exception('Firebase is not initialized');
    }
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!;
  }

  /// Get current user
  User? get currentUser {
    try {
      return auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update last login time
      if (credential.user != null) {
        await _updateUserLastLogin(credential.user!.uid);
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Register with email and password
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      if (credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        await credential.user!.reload();
        
        // Create user document in Firestore
        await _createUserDocument(
          credential.user!.uid,
          email: email,
          displayName: displayName,
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Check if Firebase is available
      if (!_isFirebaseAvailable) {
        throw Exception('Firebase is not initialized. Please check your configuration.');
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        throw Exception('Google Sign-In was cancelled by user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if we have the required tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to obtain Google authentication tokens');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential =
          await auth.signInWithCredential(credential);

      // Create or update user document
      if (userCredential.user != null) {
        try {
          await _createOrUpdateUserDocument(
            userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            displayName: userCredential.user!.displayName,
            photoUrl: userCredential.user!.photoURL,
          );
          await _updateUserLastLogin(userCredential.user!.uid);
        } catch (e) {
          // Log but don't fail - user is still signed in
          print('Warning: Failed to update user document: $e');
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Google Sign-In failed: ${_handleAuthException(e)}');
    } catch (e) {
      throw Exception('Google Sign-In failed: ${e.toString()}');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.wait([
      auth.signOut(),
      googleSignIn.signOut(),
    ]);
  }

  /// Get user model from Firebase User
  Future<UserModel> getUserModel(String uid) async {
    try {
      final userDoc = await firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        return UserModel.fromJson({
          'id': uid,
          ...userDoc.data()!,
        });
      } else {
        // If user document doesn't exist, create it
        final firebaseUser = auth.currentUser;
        if (firebaseUser != null) {
          await _createOrUpdateUserDocument(
            uid,
            email: firebaseUser.email ?? '',
            displayName: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
          );
          return getUserModel(uid);
        }
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument(
    String uid, {
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    final userData = {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'ecoPoints': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
    };

    await firestore.collection('users').doc(uid).set(userData);
  }

  /// Create or update user document
  Future<void> _createOrUpdateUserDocument(
    String uid, {
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    final userRef = firestore.collection('users').doc(uid);
    final userDoc = await userRef.get();

    if (!userDoc.exists) {
      // Create new user document
      await userRef.set({
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'ecoPoints': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Update existing user document
      await userRef.update({
        'displayName': displayName,
        'photoUrl': photoUrl,
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Update user last login time
  Future<void> _updateUserLastLogin(String uid) async {
    await firestore.collection('users').doc(uid).update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}

