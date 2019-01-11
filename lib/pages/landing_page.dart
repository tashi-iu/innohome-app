import 'package:flutter/material.dart';
import '../widgets/login_btn.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/login.jpg"),
        fit: BoxFit.cover,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            child: Text("innoHome",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w600)),
            padding: EdgeInsets.symmetric(vertical: 32),
          ),
          Padding(
            child: Text("Bhutan's first smart home solution",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: FontStyle.italic)),
            padding: EdgeInsets.fromLTRB(64, 0, 64, 128),
          ),
          Padding(
            child: LoginButton(
              child: Text(
                "Log In",
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
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');

              },
            ),
            padding: EdgeInsets.fromLTRB(64, 16, 64, 0),
          ),
          Padding(
            child: LoginButton(
              child: Text(
                "Create a new account",
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
                  Colors.grey[600],
                  Colors.grey[700],
                  Colors.grey[600],
                  Colors.grey[700]
                ],
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
            ),
            padding: EdgeInsets.fromLTRB(64, 0, 64, 0),
          ),
        ],
      ),
    ));
  }
}
