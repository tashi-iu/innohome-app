import 'package:flutter/material.dart';

class LoginInputTextField extends StatelessWidget {
  final Function onSaved;
  final String labelText;
  final String hintText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final bool obscureText;
  final String initialValue;

  const LoginInputTextField({
    Key key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSaved,
    this.controller,
    this.keyboardType,
    this.validator,
    this.obscureText,
    this.initialValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.4),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.cyan),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
