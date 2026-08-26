import 'package:agroscan/screens/signin_screen.dart';
import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:agroscan/widgets/navbar.dart';
import 'package:agroscan/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _passwordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _passwordError = 'Passwords do not match');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavBarRoots()),
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        _passwordError = switch (error.code) {
          'email-already-in-use' => 'An account already exists for this email.',
          'invalid-email' => 'Enter a valid email address.',
          'weak-password' => 'Password must be at least 6 characters.',
          _ => 'Sign-up failed (${error.code})',
        };
      });
    } catch (error) {
      if (kDebugMode) print(error);
      setState(() => _passwordError = 'Sign-up failed. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AgroAuthShell(
      showBack: true,
      title: 'Create Your Account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReusableTextField(
            text: 'Full name',
            icon: Icons.person_outline_rounded,
            isPasswordType: false,
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          ReusableTextField(
            text: 'Email address',
            icon: Icons.mail_outline_rounded,
            isPasswordType: false,
            controller: _emailController,
          ),
          const SizedBox(height: 16),
          ReusableTextField(
            text: 'Password (min 6 characters)',
            icon: Icons.lock_outline_rounded,
            isPasswordType: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 16),
          ReusableTextField(
            text: 'Confirm password',
            icon: Icons.lock_outline_rounded,
            isPasswordType: true,
            controller: _confirmPasswordController,
            errorText: _passwordError,
          ),
          const SizedBox(height: 24),
          signInSignUpButton(context, false, _signUp),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                ),
                child: const Text(
                  'Sign In',
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
