/*

FIREBASE AUTH BACKEND

*/

import 'package:ramadancompanionapp/services/auth/domain/models/app_user.dart';
import 'package:ramadancompanionapp/services/auth/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements AuthRepo {
  // access firebase auth instance
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // LOGIN: email & password
  @override
  Future<AppUser?> loginWithEmailPassword(
      String email, String password) async {
    try {
      // attempt login
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password);

      // create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName ?? '',
      );

      // return user
      return user;
    } on FirebaseAuthException catch (e) {
      String message;
      message = '$e';
      // Map Firebase error codes to user-friendly messages
      // switch (e.code) {
      //   case 'invalid-email':
      //     message = 'The email address is not valid.';
      //     break;
      //   case 'user-disabled':
      //     message = 'This user has been disabled.';
      //     break;
      //   case 'user-not-found':
      //     message = 'No user found with this email.';
      //     break;
      //   case 'wrong-password':
      //     message = 'Incorrect password.';
      //     break;
      //   default:
      //     message = 'Login failed. Please try again.';
      // }
      throw Exception(
          message); // throw with friendly message
    } catch (e) {
      throw Exception(
          'Something went wrong. Please try again.');
    }
  }

  // REGISTER: email & password
  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      // attempt registration
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user!.updateDisplayName(name);

      // Reload user to ensure changes are reflected
      await userCredential.user!.reload();

      // create user
      AppUser user = AppUser(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: name);

      // return user
      return user;
    } catch (e) {
      throw Exception(
          'Something went wrong. Please try again.');
    }
  }

  // GET CURRENT USER
  @override
  Future<AppUser?> getCurrentUser() async {
    // get current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;

    // no logged in user
    if (firebaseUser == null) return null;

    // logged user exists
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: firebaseUser.displayName ?? 'Guest',
    );
  }

  // LOGOUT
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  // AUTH STATE CHANGES
  @override
  Stream<User?> authStateChanges() =>
      firebaseAuth.authStateChanges();
}
