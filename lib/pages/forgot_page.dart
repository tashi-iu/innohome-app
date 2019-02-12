import 'package:flutter/material.dart';
import '../widgets/login_field.dart';
import 'login_page.dart';

class ForgotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _fKey = GlobalKey<FormState>();

  String _emailAddress = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                "Oops!",
                style: TextStyle(color: Colors.white, fontSize: 48),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32, 48, 32, 0),
                child: Text(
                  "Looks like you forgot your password. You can get the innoHome password sent to your mail",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                "Enter your email address",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 0),
                  child: Form(
                    key: _fKey,
                    autovalidate: true,
                    child: LoginInputTextField(
                      obscureText: false,
                      validator: _validateEmail,
                      controller: null,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) {
                        this._emailAddress = val;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TO-DO Rinzin
                          if (_fKey.currentState.validate()) {
                            _fKey.currentState.save();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SentMailPage(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
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
}

class SentMailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SentMailPageState();
  }
}

class _SentMailPageState extends State<SentMailPage> {
  bool _sending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 128,
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Text(
                  "Password reset procedures were sent to your mail",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              FlatButton(
                child: Text(
                  "Go back to login page",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
