import 'package:flutter/material.dart';

import '../widgets/login_btn.dart';
import '../widgets/login_field.dart';

import 'dart:ui';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _signUpKey = GlobalKey<FormState>();

  String password;
  String userId;

  String _validateUserId(String value) {
    if (value.isEmpty) {
      return "Enter user Id";
    }

    if (value.length < 5) {
      return "Minimum length for user name is 5";
    }

    String p = "[A-Za-z0-9]";

    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }

    return 'User ID is not valid';
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "Enter your password";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/login.jpg",
              ),
              fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            color: Colors.white.withOpacity(0.8),
            child: Form(
              autovalidate: true,
              key: _signUpKey,
              child: _loginPage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginPage() {
    return ListView(
      reverse: true,
      children: <Widget>[
        LoginButton(
          child: Text(
                "LOG IN",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                          color: Colors.deepPurple,
                          offset: Offset(1, 1),
                          blurRadius: 1),
                    ],),
              ),
          gradient: LinearGradient(
                colors: <Color>[
                  Colors.cyanAccent,
                  Colors.blue[600],
                  Colors.blue[800],
                  Colors.deepPurple[900]
                ],
              ),
          onPressed: () {
            if (_signUpKey.currentState.validate()) {
              print("validation completed");
            }
          },
        ),
        LoginInputTextField(
          labelText: "Password",
          obscureText: true,
          keyboardType: TextInputType.text,
          validator: _validatePassword,
          onSaved: (value) {
            this.password = value;
          },
        ),
        LoginInputTextField(
          labelText: "Username",
          hintText: "dorji72",
          obscureText: false,
          validator: _validateUserId,
          onSaved: (value) {
            this.userId = value;
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            "Log In",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
