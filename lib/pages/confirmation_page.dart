import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_switch_v2/model/user.dart';

import '../widgets/login_btn.dart';
import '../widgets/login_field.dart';

import 'house_page.dart';

import '../util/network_util.dart';
import '../util/database_helper.dart';

class ConfirmationPage extends StatefulWidget {
  final String email;
  final String deviceId;
  ConfirmationPage(this.email, this.deviceId);
  @override
  State<StatefulWidget> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  var db = DatabaseHelper();

  bool _loading = false;

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
    return ListView(
      reverse: true,
      children: <Widget>[
        _confirmButton(),
        FlatButton(
          child: Text("RESEND CODE"),
          onPressed: () {
            Navigator.pop(context);
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
            "Please enter the code sent to your mail. Please check your spam folder.",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _confirmButton() {
    return LoginButton(
      child: Text(
        _loading ? CircularProgressIndicator() : "CONFIRM",
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
                    await verifySignUp(widget.email, code);
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
                      "Unfortunately, there seems to be an error. Please try again later, or contact customer care");
                } else if (type == "success") {
                  print(x_auth);
                  User user = User(x_auth, widget.deviceId);
                  int result;
                  result = await db.saveUser(user);

                  if (result != 0) {
                    print("user saved");
                    Navigator.pushReplacementNamed(context, "/rooms");
                  } else {
                    print("error ");
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
