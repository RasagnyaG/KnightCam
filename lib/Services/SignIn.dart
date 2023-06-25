import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  googleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return;
      }
      _user = result;
      notifyListeners();
      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
