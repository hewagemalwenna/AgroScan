import 'package:agroscan/screens/signup_screen.dart';
import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/tools/auth_service.dart';
import 'package:agroscan/tools/square_tile.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:agroscan/widgets/navbar.dart';
import 'package:agroscan/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _passwordError = 'Enter email and password');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavBarRoots()),
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        _passwordError = switch (error.code) {
          'user-not-found' ||
          'invalid-credential' ||
          'wrong-password' ||
          'INVALID_LOGIN_CREDENTIALS' =>
            'Wrong email/password, or use Google Sign-In for Gmail accounts.',
          'invalid-email' => 'Enter a valid email address',
          'network-request-failed' => 'Network error. Check your connection.',
          _ => 'Sign-in failed (${error.code})',
        };
      });
    } catch (error) {
      if (kDebugMode) print(error);
      setState(() => _passwordError = 'Sign-in failed. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AgroAuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReusableTextField(
            text: 'Email address',
            icon: Icons.mail_outline_rounded,
            isPasswordType: false,
            controller: _emailController,
          ),
          const SizedBox(height: 16),
          ReusableTextField(
            text: 'Password',
            icon: Icons.lock_outline_rounded,
            isPasswordType: true,
            controller: _passwordController,
            errorText: _passwordError,
          ),
          const SizedBox(height: 24),
          signInSignUpButton(context, true, _signIn),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'or continue with',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SquareTile(
                onTap: () => Authentication().signInWithGoogle(context),
                imagePath: 'assets/images/google.png',
                label: 'Google',
              ),
              const SizedBox(width: 12),
              SquareTile(
                onTap: () {},
                imagePath: 'assets/images/apple.png',
                label: 'Apple',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New to AgroScan? ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    color: AgroScanTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
