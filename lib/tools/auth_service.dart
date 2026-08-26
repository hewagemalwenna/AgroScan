import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

/// Returns the signed-in user's UID, or throws if nobody is signed in.
Future<String> getUserId() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw StateError('No signed-in user');
  }
  return user.uid;
}

class Authentication {
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        // User cancelled the Google picker.
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, 'NavBarRoots');
      }
      return userCredential;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: $e')),
        );
      }
      return null;
    }
  }
}
