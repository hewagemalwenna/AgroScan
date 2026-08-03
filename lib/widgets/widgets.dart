import "package:flutter/material.dart";


// ignore: must_be_immutable
class ReusableTextField extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isPasswordType;
  final TextEditingController controller;
  final TextEditingController? retypePasswordController;
  String? errorText;

  ReusableTextField({
    required this.text,
    required this.icon,
    required this.isPasswordType,
    required this.controller,
    this.retypePasswordController,
    this.errorText,

    Key? key,
  }) : super(key: key);

  @override
  ReusableTextFieldState createState() => ReusableTextFieldState();
}

class ReusableTextFieldState extends State<ReusableTextField> {
  bool obscureText = true;


  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.controller,
        obscureText: widget.isPasswordType? obscureText: false,
        enableSuggestions: !widget.isPasswordType,
        autocorrect: !widget.isPasswordType,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.black.withOpacity(0.9)),
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
            color: Colors.black,
          ),
          labelText: widget.text,
          labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          suffixIcon: widget.isPasswordType?GestureDetector(
            onTap: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
          ):null,
          errorText: widget.errorText,
        ),
        keyboardType: widget.isPasswordType
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        onChanged: (value) {
          if (widget.retypePasswordController != null) {
            if (widget.controller.text != widget.retypePasswordController!.text) {
              widget.retypePasswordController!.text = '';
              setState(() {
                widget.errorText = 'Passwords do not match';
              });
            } else {
              setState(() {
                widget.errorText = null;
              });
            }
          }
        }
    );
  }
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap){
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: (){
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states){
              if (states.contains(MaterialState.pressed)){
                return Colors.black87;
              }
              return Colors.white;
            } ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
        child: Text(
          isLogin? "LOG IN": "SIGN UP",
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16
          ),
        ),
      )

  );
}