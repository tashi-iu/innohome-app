import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_switch_v2/model/user.dart';

import '../widgets/login_btn.dart';
import '../widgets/login_field.dart';

import 'house_page.dart';

import '../util/network_util.dart';
import '../util/database_helper.dart';

class LoginConfirmationPage extends StatefulWidget {
  final String email;

  LoginConfirmationPage(this.email);
  
  @override
  State<StatefulWidget> createState() => _LoginConfirmationPageState();
}

class _LoginConfirmationPageState extends State<LoginConfirmationPage> {
  var db = DatabaseHelper();

  final _signUpKey = GlobalKey<FormState>();
  TextEditingController _verificationController = new TextEditingController();

  String _validateLoginCode(String value) {
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
            // TO-DO RINZIN : Resend code to email function
          },
        ),
        LoginInputTextField(
          obscureText: false,
          controller: _verificationController,
          validator: _validateLoginCode,
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
      onPressed: () async {
        if (_signUpKey.currentState.validate()) {
          String code = _verificationController.text;

          Map<String, String> response = await verifyLogin(widget.email, code);

          String x_auth = response["x-auth"];
          String message = response["message"];
          String type = response["type"];
          String deviceId = response["deviceId"];

          if (type == "null") {
            //dialog box error
            //to do tashi no network,

          } else if (type == "error") {
            //to do tashi
            //dialog box error
            //print the message
          } else if (type == "success") {
            
            User user = await db.getUser(1);
            
            if(user == null){
              User user = User(x_auth, deviceId);
              int res = await db.saveUser(user);
              if(res != 0){
              print("user saved login");
              Navigator.pushReplacementNamed(context, "/rooms");
            }

            }
            Map<String, dynamic> obj = user.toMap();
            User updatedUser = User.fromMap({"id": obj["id"], "userToken":x_auth, "deviceId": obj["deviceId"]});
            
            int res = await db.updateUser(updatedUser);
            
            if(res != 0){
              print("user updated");
              Navigator.pushReplacementNamed(context, "/rooms");
            }
          }
        }
      },
    );
  }
}
