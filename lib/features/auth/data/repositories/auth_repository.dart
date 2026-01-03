import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Authentication repository
class AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepository(this._dataSource);

  /// Get current user
  User? get currentUser => _dataSource.currentUser;

  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _dataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    if (credential.user == null) {
      throw Exception('User is null after sign in');
    }

    return await _dataSource.getUserModel(credential.user!.uid);
  }

  /// Register with email and password
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _dataSource.registerWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (credential.user == null) {
      throw Exception('User is null after registration');
    }

    return await _dataSource.getUserModel(credential.user!.uid);
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    final credential = await _dataSource.signInWithGoogle();

    if (credential.user == null) {
      throw Exception('User is null after Google sign in');
    }

    return await _dataSource.getUserModel(credential.user!.uid);
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _dataSource.sendPasswordResetEmail(email);
  }

  /// Sign out
  Future<void> signOut() async {
    await _dataSource.signOut();
  }

  /// Get current user model
  Future<UserModel?> getCurrentUserModel() async {
    final user = _dataSource.currentUser;
    if (user == null) return null;
    
    try {
      return await _dataSource.getUserModel(user.uid);
    } catch (e) {
      return null;
    }
  }
}


