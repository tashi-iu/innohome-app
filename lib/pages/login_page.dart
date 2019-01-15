import 'package:flutter/material.dart';
import 'package:smart_switch_v2/util/database_helper.dart';

import '../widgets/login_btn.dart';
import '../widgets/login_field.dart';

import 'dart:ui';

import '../model/user.dart';

import '../util/network_util.dart';
import '../widgets/error_popup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _signUpKey = GlobalKey<FormState>();

  var db = DatabaseHelper();
  String password;
  String email;

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
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "Enter your password";
    }
    return null;
  }

  bool _awaitLogIn = false;

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
        LoginButton(
          child: _awaitLogIn ? CircularProgressIndicator() : Text(
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
              ],
            ),
          ),
          gradient: LinearGradient(
            colors: <Color>[
              Colors.cyanAccent,
              Colors.blue[600],
              Colors.blue[800],
              Colors.deepPurple[900]
            ],
          ),
          onPressed: _awaitLogIn ? (){return null;} : () async {
            if (_signUpKey.currentState.validate()) {
              _signUpKey.currentState.save();
              print("validation completed");
              print("$email, $password");
              setState(() {
                _awaitLogIn = true;
              });
              Map<String, String> response = await login(email, password);
              setState(() {
                _awaitLogIn = false;
              });

              String error_message = response["error_message"];
              String x_auth = response["x_auth"];

              if (error_message == "null" && x_auth == "null") {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ErrorPopup(
                        text: error_message,
                      );
                    });
              } else if (x_auth == "null") {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ErrorPopup(
                        text: error_message,
                      );
                    });
              } else if (error_message == "null") {
                User user = User.fromMap({"userId": 1, "userToken": x_auth});

                int result = await db.updateUser(user);

                if (result != 0) {
                  Navigator.pushReplacementNamed(context, "/rooms");
                }
              }
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
          labelText: "Email",
          hintText: "dorji72@gmail.com",
          obscureText: false,
          validator: _validateEmail,
          onSaved: (value) {
            this.email = value;
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
