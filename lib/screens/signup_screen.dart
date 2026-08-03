

import "package:agroscan/screens/signin_screen.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:agroscan/widgets/navbar.dart";
import "package:agroscan/widgets/widgets.dart";

import "../tools/colors.dart";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _retypePasswordTextController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Add functionality to close the page
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen()));
            },
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("03B321"),
                hexStringToColor("19ED3E"),
                hexStringToColor("55F571")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.175, 20, 0),
                child: Column(
                  children: <Widget>[
                    const Center(
                      child: CircleAvatar(
                        backgroundImage:
                        AssetImage("assets/images/profileImage.jpg"),
                        radius: 90.0,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                        text: "Name",
                        icon: Icons.person_outline,
                        isPasswordType: false,
                        controller: _userNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                        text: "Email",
                        icon: Icons.person_outline,
                        isPasswordType: false,
                        controller: _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                        text: "Password(min 6 characters)",
                        icon: Icons.lock_outlined,
                        isPasswordType: true,
                        controller: _passwordTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                      // confirming if the above password is the same
                        text: "Confirm Password",
                        icon: Icons.lock_outlined,
                        isPasswordType: true,
                        controller: _retypePasswordTextController,
                        errorText: _passwordTextController.text !=
                            _retypePasswordTextController.text
                            ? "passwords do not match"
                            : null),
                    const SizedBox(
                      height: 20,
                    ),
                    signInSignUpButton(context, false, () {
                      if (_passwordTextController.text !=
                          _retypePasswordTextController.text) {
                        if (kDebugMode) {
                          print("passwords do not match");
                        }
                        return;
                      } // if condition to check if user entered password correcty.
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                          .then((value) {
                        if (kDebugMode) {
                          print("New Account Created");
                        }
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NavBarRoots()));
                      }).onError((error, stackTrace) {
                        if (kDebugMode) {
                          print("error ${error.toString()}");
                        }
                      });
                    })
                  ],
                )),
          ),
        ));
  }
}
Future<String>getUserId()async{
  User user=FirebaseAuth.instance.currentUser!;
  return user.uid;
}