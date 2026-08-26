import 'package:agroscan/tools/app_theme.dart';
import 'package:flutter/material.dart';

class ReusableTextField extends StatefulWidget {
  const ReusableTextField({
    super.key,
    required this.text,
    required this.icon,
    required this.isPasswordType,
    required this.controller,
    this.retypePasswordController,
    this.errorText,
  });

  final String text;
  final IconData icon;
  final bool isPasswordType;
  final TextEditingController controller;
  final TextEditingController? retypePasswordController;
  final String? errorText;

  @override
  ReusableTextFieldState createState() => ReusableTextFieldState();
}

class ReusableTextFieldState extends State<ReusableTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPasswordType ? obscureText : false,
      enableSuggestions: !widget.isPasswordType,
      autocorrect: !widget.isPasswordType,
      style: const TextStyle(color: AgroScanTheme.text),
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon, color: AgroScanTheme.mutedText, size: 22),
        labelText: widget.text,
        labelStyle: const TextStyle(color: AgroScanTheme.mutedText),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: widget.text,
        suffixIcon: widget.isPasswordType
            ? IconButton(
                onPressed: () => setState(() => obscureText = !obscureText),
                icon: Icon(
                  obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AgroScanTheme.mutedText,
                ),
              )
            : null,
        errorText: widget.errorText,
      ),
      keyboardType: widget.isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      onChanged: (_) {
        if (widget.retypePasswordController != null) {
          setState(() {});
        }
      },
    );
  }
}

Widget signInSignUpButton(
  BuildContext context,
  bool isLogin,
  VoidCallback onTap,
) {
  return SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onTap,
      child: Text(isLogin ? 'Sign In' : 'Create Account'),
    ),
  );
}
