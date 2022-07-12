part of 'helpers.dart';

class AuthException {
  AuthException._();

  static AuthResult signInException(FirebaseAuthException e) {
    AuthResult result = AuthResult(status: false, message: e.message);

    switch (e.code) {
      case 'invalid-email':
        result.message = 'The email address is badly formatted.';
        break;
      case 'user-not-found':
        result.message = 'Email Address not registered with us.';
        break;
      case 'wrong-password':
        result.message = 'Password is incorrect.';
        break;
      default:
    }
    return result;
  }

  static AuthResult signUpException(FirebaseAuthException e) {
    AuthResult result = AuthResult(status: false, message: e.message);

    switch (e.code) {
      case 'email-already-in-use':
        result.message = 'This Email address already registered.';
        break;
      default:
    }
    return result;
  }

  static AuthResult changePasswordException(FirebaseAuthException e) {
    AuthResult result = AuthResult(status: false, message: e.message);

    switch (e.code) {
      case 'user-not-found':
        result.message = 'Email Address not registered with us.';
        break;
      case 'wrong-password':
        result.message = 'Old Password is incorrect.';
        break;
      default:
    }
    return result;
  }

  static AuthResult resetPasswordException(FirebaseAuthException e) {
    AuthResult result = AuthResult(status: false, message: e.message);

    switch (e.code) {
      case 'user-not-found':
        result.message = 'Email Address not registered with us.';
        break;
      default:
    }
    return result;
  }
}
