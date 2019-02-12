import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/login_btn.dart';
import 'house_page.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final _signUpKey = GlobalKey<FormState>();
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
        FlatButton(
          child: Text("CHANGE EMAIL"),
          onPressed: () {
            // TO-DO RINZIN : Go back to sign up page
          },
        ),
        _confirmButton(),
        FlatButton(
          child: Text("RESEND CODE"),
          onPressed: () {
            // TO-DO RINZIN : Resend code to email function
          },
        ),
        Row(
          children: <Widget>[_numberField()],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            "Please verify your email",
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
        // TO-DO RINZIN : Go into House Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HousePage(),
          ),
        );
      },
    );
  }

  Widget _numberField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(),
    );
  }
}
