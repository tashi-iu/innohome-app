import 'package:flutter/material.dart';
import 'package:smart_switch_v2/pages/login_confirmation.dart';
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
  String phone;

  String _validatePhone(String value) {
    if (value.isEmpty || value.length != 8 || int.tryParse(value) == null) {
      return "Enter a valid phone number";
    }
    return null;
  }

  bool _awaitLogIn = false;

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
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
        LoginButton(
          child: _awaitLogIn
              ? CircularProgressIndicator()
              : Text(
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
          onPressed: _awaitLogIn
              ? () {
                  return null;
                }
              : () async {
                  if (_signUpKey.currentState.validate()) {
                    _signUpKey.currentState.save();
                    print("validation completed");
                    print("$phone");
                    setState(() {
                      _awaitLogIn = true;
                    });
                    Map<String, String> response = await login(phone);
                    //   Map<String, String> response = await login(email, password);
                    setState(() {
                      _awaitLogIn = false;
                    });

                    String message = response["message"];
                    String type = response["type"];

                    if (type == "null") {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ErrorPopup(
                              text:
                                  "Signup failed. Check your internet connection and try again.",
                            );
                          });
                    } else if (type == "error") {
                      print(message);
                      print("hello from error");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ErrorPopup(
                              text: message,
                            );
                          });
                    } else if (type == "success") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginConfirmationPage(phone),
                        ),
                      );
                    }
                    //   if (error_message == "null" && x_auth == "null") {
                    //     showDialog(
                    //         context: context,
                    //         builder: (context) {
                    //           return ErrorPopup(
                    //             text:
                    //                 "Could not connect to server. Check your connection and try again",
                    //           );
                    //         });
                    //   } else if (x_auth == "null") {
                    //     showDialog(
                    //         context: context,
                    //         builder: (context) {
                    //           return ErrorPopup(
                    //             text:
                    //                 "Login failed. Make sure you are registered and recheck the fields.",
                    //           );
                    //         });
                    //   } else if (error_message == "null") {
                    //     User user = User(response["x_auth"], "qwertyuiop");
                    //     int result = await db.saveUser(user);

                    //     if (result != 0) {
                    //       Navigator.pushReplacementNamed(context, "/rooms");
                    //     }
                    //   }
                  }
                },
        ),
        LoginInputTextField(
          labelText: "Phone Number",
          keyboardType: TextInputType.number,
          hintText: "17654321",
          obscureText: false,
          validator: _validatePhone,
          onSaved: (value) {
            this.phone = value;
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
