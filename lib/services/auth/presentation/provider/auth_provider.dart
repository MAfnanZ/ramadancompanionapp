/*

Auth State Management

*/

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ramadancompanionapp/services/auth/domain/models/app_user.dart';
import 'package:ramadancompanionapp/services/auth/domain/repos/auth_repo.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_states.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthProvider({required this.authRepo}) {
    _listenToAuthChanges();
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  late final StreamSubscription<User?> _authSub;

  /// Listen to Firebase auth state changes
  void _listenToAuthChanges() {
    _authSub =
        authRepo.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        _currentUser = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          name: firebaseUser.displayName ?? '',
        );
        _setState(Authenticated(user: _currentUser!));
      } else {
        _currentUser = null;
        _setState(Unauthenticated());
      }
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  // get current user
  AppUser? get currentUser => _currentUser;

  AuthState _state = AuthInitial();
  AuthState get state => _state;

  // Login with email & password
  Future<void> login(String email, String pw) async {
    _setState(AuthLoading());
    try {
      final user =
          await authRepo.loginWithEmailPassword(email, pw);
      if (user != null) {
        _currentUser = user;
        _setState(Authenticated(user: user));
      } else {
        _currentUser = null;
        _setState(Unauthenticated());
      }
    } catch (e) {
      _setState(AuthError(message: e.toString()));
    }
  }

  // Register with email & password
  Future<void> register(
      String name, String email, String pw) async {
    _setState(AuthLoading());
    try {
      final user = await authRepo.registerWithEmailPassword(
          name, email, pw);
      if (user != null) {
        _currentUser = user;
        _setState(Authenticated(user: user));
      } else {
        _currentUser = null;
        _setState(Unauthenticated());
      }
    } catch (e) {
      _setState(AuthError(message: e.toString()));
    }
  }

  // Logout
  Future<void> logout() async {
    _setState(AuthLoading());
    await authRepo.logout();
    _currentUser = null;
    _setState(Unauthenticated());
  }
}
