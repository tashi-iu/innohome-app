import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_switch_v2/widgets/error_popup.dart';

import './confirmation_page.dart';
import '../model/user.dart';
import '../util/database_helper.dart';
import '../util/network_util.dart';
import '../widgets/login_btn.dart';
import '../widgets/login_field.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final _signUpKey = GlobalKey<FormState>();

  String email;
  String password;
  String deviceId;
  String username;
  int noOfRooms;

  bool progress = false;

  var db = new DatabaseHelper();

  TextEditingController _passwordController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    super.initState();
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Email address cannot be empty";
    }
    //regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      //the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Email is not valid';
  }

  String _validateDeviceId(String value) {
    if (value.isEmpty) {
      return "Device ID cannot be empty";
    }

    if (value.length < 5) {
      return "Length of device ID shoud be greater than 5";
    }
    return null;
  }

  String _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return "Enter your password again";
    }
    if (value != _passwordController.text) {
      return "Password does not match";
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 7) {
      return "Minimum password length is 8";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.cyan),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
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
              autovalidate: false,
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
        _loginButton(),
        LoginInputTextField(
          labelText: "Device ID",
          hintText: "Check your innoHome device",
          prefixIcon: Icon(Icons.perm_device_information),
          validator: _validateDeviceId,
          controller: null,
          onSaved: (value) {
            this.deviceId = value;
          },
          obscureText: false,
        ),
        LoginInputTextField(
          labelText: "Retype new password",
          prefixIcon: Icon(Icons.lock),
          keyboardType: TextInputType.text,
          validator: _validateConfirmPassword,
          obscureText: true,
        ),
        LoginInputTextField(
          labelText: "New password",
          prefixIcon: Icon(Icons.lock),
          keyboardType: TextInputType.text,
          validator: _validatePassword,
          controller: _passwordController,
          onSaved: (value) {
            this.password = value;
          },
          obscureText: true,
        ),
        LoginInputTextField(
          labelText: "Email address",
          hintText: "dorji@gmail.bt",
          prefixIcon: Icon(Icons.email),
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
          controller: null,
          onSaved: (value) {
            this.email = value;
          },
          obscureText: false,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            "Create account",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _loginButton() {
    return LoginButton(
      child: progress
          ? CircularProgressIndicator()
          : Text(
              "SIGN UP",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                        color: Colors.deepPurple,
                        offset: Offset(1, 1),
                        blurRadius: 1),
                  ],
                  letterSpacing: 1.2),
            ),
      gradient: LinearGradient(
        colors: <Color>[
          Colors.cyanAccent,
          Colors.blue[600],
          Colors.blue[800],
          Colors.deepPurple[900]
        ],
      ),
      onPressed: progress
          ? () {}
          : () async {
              setState(() {
                progress = true;
              });
              if (_signUpKey.currentState.validate()) {
                _signUpKey.currentState.save();

                Map<String, String> response =
                    await signUp(email, deviceId, noOfRooms, password);

                String error_message = response["error_message"];
                String x_auth = response["x_auth"];

                if (error_message == "null" && x_auth == "null") {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ErrorPopup(
                          text:
                              "Signup failed. Check your internet connection and try again.",
                        );
                      });
                  print("oops sth is very wrong");
                } else if (x_auth == "null") {
                  print(error_message);
                  print("hello from error");
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ErrorPopup(
                          text: "Signup failed. Email is already registered.",
                        );
                      });
                } else if (error_message == "null") {
                  print(response["x_auth"]);
                  User user = User(response["x_auth"], deviceId);
                  int result = await db.saveUser(user);

                  if (result != 0) {
                    print("user saved");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmationPage(),
                      ),
                    );
                  } else {
                    print("not good");
                  }
                }
              }
              setState(() {
                progress = false;
              });
            },
    );
  }
}
