import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:agroscan/tools/auth_service.dart";
import "package:agroscan/widgets/navbar.dart";
import "package:agroscan/widgets/widgets.dart";
import "package:agroscan/screens/signup_screen.dart";
import "package:agroscan/tools/colors.dart";

import "../tools/square_tile.dart";

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  String? _passwordTextError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("03B321"),
              hexStringToColor("19ED3E"),
              hexStringToColor("55F571")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.175,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                const Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/profileImage.jpg"),
                    radius: 90.0,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ReusableTextField(
                  text: "Username",
                  icon: Icons.person_outline,
                  isPasswordType: false,
                  controller: _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                ReusableTextField(
                  text: "Password",
                  icon: Icons.lock_outline,
                  isPasswordType: true,
                  controller: _passwordTextController,
                  errorText: _passwordTextError,
                ),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  )
                      .then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavBarRoots(),
                      ),
                    );
                  }).onError((error, stackTrace) {
                    setState(() {
                      _passwordTextError = "Incorrect password";
                    });
                    if (kDebugMode) {
                      print("Error ${error.toString()}");
                    }
                  });
                }),
                const SizedBox(height: 20),
                // Or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Continue with',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Google and Apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Aligns the buttons in the center with some space between them
                  children: [
                    // Google button
                    SquareTile(
                        onTap: () => Authentication().signInWithGoogle(context),
                        imagePath: 'assets/images/google.png'),
                    // Apple button
                    SquareTile(
                        onTap: () {}, imagePath: 'assets/images/apple.png'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                signUpOption(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // method to show the signup button to navigate to signup screen
  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Or Create An Account : ",
          style: TextStyle(color: Colors.black87),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
Future<String>getUserId()async{
  User user=FirebaseAuth.instance.currentUser!;
  return user.uid;
}