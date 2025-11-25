/*

AUTH STATES

*/

import 'package:ramadancompanionapp/services/auth/domain/models/app_user.dart';

abstract class AuthState {}

// Initial state
class AuthInitial extends AuthState {}

// Loading state
class AuthLoading extends AuthState {}

// Authenticated state
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated({required this.user});
}

// Unauthenticated state
class Unauthenticated extends AuthState {}

// Error state
class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
