/*

AUTH REPOSITORY - Outlines the possible auth operations for this app

*/

import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(
    String email,
    String password,
  );
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  );
  Future<AppUser?> getCurrentUser();
  Future<void> logout();
  Stream<User?> authStateChanges();
}
