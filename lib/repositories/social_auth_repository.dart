
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthRepository {
  //
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AuthResult> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return AuthResult(status: true, user: userCredential.user);
      //
    } on FirebaseAuthException catch (e) {
      return AuthResult(status: false, message: e.message);
    }
  }

  Future<AuthResult> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await _facebookAuth.login();
      if (loginResult.status == LoginStatus.success) {
        final AccessToken? accessToken = loginResult.accessToken;

        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken?.token ?? '');

        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        return AuthResult(status: true, user: userCredential.user);
      } else {
        return AuthResult(status: false, message: 'Facebook authentication failed');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult(status: false, message: e.message);
    }
  }

  Future<AuthResult> signInWithApple() async {
    try {
      AuthorizationCredentialAppleID appleIdCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: AppleIDAuthorizationScopes.values,
      );
      OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      OAuthCredential credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return AuthResult(status: true, user: userCredential.user);

      //
    } on FirebaseAuthException catch (e) {
      return AuthResult(status: false, message: e.message);
    }
  }

  Future<void> signOut(AuthType? type) async {
    await _firebaseAuth.signOut();

    switch (type) {
      case AuthType.google:
        await _googleSignIn.signOut();
        break;
      case AuthType.facebook:
        _facebookAuth.logOut();
        break;
      default:
    }
  }
}
