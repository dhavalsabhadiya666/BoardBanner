import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  //
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthResult> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(status: true, user: credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthException.signUpException(e);
    }
  }

  Future<AuthResult> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(status: true, user: credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthException.signInException(e);
    }
  }

  Future<AuthResult> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: oldPassword,
      );
      var userCredential = await user!.reauthenticateWithCredential(credential);
      await userCredential.user?.updatePassword(newPassword);
      return AuthResult(status: true);
    } on FirebaseAuthException catch (e) {
      return AuthException.changePasswordException(e);
    }
  }

  Future<AuthResult> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult(
        status: true,
        message: 'Password reset link sent your registered Email address.',
      );
    } on FirebaseAuthException catch (e) {
      return AuthException.resetPasswordException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  static AuthenticationStatus getAuthenticationStatus() {
    return _auth.currentUser != null
        ? AuthenticationStatus.authenticated
        : AuthenticationStatus.unauthenticated;
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  User? get user => _auth.currentUser;
}
