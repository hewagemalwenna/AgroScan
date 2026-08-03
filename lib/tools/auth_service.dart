import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';


class Authentication {
  signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    if (context.mounted) { // Checking if context is still valid
      Navigator.pushReplacementNamed(context, "NavBarRoots");
    }

    return await FirebaseAuth.instance.signInWithCredential(credential);


  }
}
