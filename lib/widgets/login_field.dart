import 'package:flutter/material.dart';

class LoginInputTextField extends StatelessWidget {
  final Function onSaved;
  final String labelText;
  final String hintText;
  final Widget prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final bool obscureText;

  const LoginInputTextField({
    Key key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.onSaved,
    this.controller,
    this.keyboardType,
    this.validator,
    this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan),
                borderRadius: BorderRadius.circular(28))),
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
