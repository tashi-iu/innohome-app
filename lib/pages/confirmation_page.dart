import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_switch_v2/model/user.dart';
import 'package:smart_switch_v2/widgets/error_popup.dart';

import '../widgets/login_btn.dart';
import '../widgets/login_field.dart';

import 'house_page.dart';

import '../util/network_util.dart';
import '../util/database_helper.dart';

class ConfirmationPage extends StatefulWidget {
  final String phone;
  final String deviceId;
  ConfirmationPage(this.phone, this.deviceId);
  @override
  State<StatefulWidget> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  var db = DatabaseHelper();

  bool _loading = false;
  bool _resending = false;

  final _signUpKey = GlobalKey<FormState>();
  TextEditingController _verificationController = new TextEditingController();

  String _validateVerificationCode(String value) {
    if (value.isEmpty) {
      return "Device ID cannot be empty";
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
              autovalidate: false,
              key: _signUpKey,
              child: _verifyPage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _verifyPage() {
    if (_resending) {
      return Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    }
    return ListView(
      reverse: true,
      children: <Widget>[
        _confirmButton(),
        FlatButton(
          child: Text("RESEND CODE"),
          onPressed: () async {
            setState(() {
              _resending = true;
            });

            Map<String, String> response = await resendSignUpCode(widget.phone);

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
              showDialog(
                  context: context,
                  builder: (context) {
                    return ErrorPopup(
                      text: message,
                    );
                  });
            }

            setState(() {
              _resending = false;
            });
          },
        ),
        LoginInputTextField(
          obscureText: false,
          controller: _verificationController,
          validator: _validateVerificationCode,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            "Please enter the code sent to your phone",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _confirmButton() {
    return LoginButton(
      child: _loading
          ? CircularProgressIndicator()
          : Text(
              "CONFIRM",
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
      onPressed: _loading
          ? () {}
          : () async {
              if (_signUpKey.currentState.validate()) {
                String code = _verificationController.text;
                setState(() {
                  _loading = true;
                });
                Map<String, String> response =
                    await verifySignUp(widget.phone, code);
                setState(() {
                  _loading = false;
                });
                String x_auth = response["x-auth"];
                String message = response["message"];
                String type = response["type"];

                if (type == "null") {
                  _showDialog("You don't seem to be connected to the internet");
                } else if (type == "error") {
                  _showDialog(
                      "$message");
                } else if (type == "success") {
                  print(x_auth);
                  User user = User(x_auth, widget.deviceId);
                  int result;
                  result = await db.saveUser(user);

                  if (result != 0) {
                    print("user saved");
                    Navigator.pushReplacementNamed(context, "/rooms");
                  } else {
                    _showDialog("Could not save to local database, try again");
                  }
                }

                // Map<String, String> obj = {
                //   "message": "null",
                //   "type": "null",
                //   "x-auth": "null"
                // };

              }
            },
    );
  }

  void _showDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    text,
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: FlatButton(
                      child: Text(
                        "Dismiss",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
