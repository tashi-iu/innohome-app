import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _signUpKey = GlobalKey<FormState>();

  String password;
  String userId;

  String _validateUserId(String value){
    if (value.isEmpty){
      return "Enter user Id";
    }

    if(value.length < 5){
      return "Minimum length for user name is 5";  
    }

    String p = "[A-Za-z0-9]";

    RegExp regExp = new RegExp(p);

    if(regExp.hasMatch(value)){
      return null;
    }

    return 'User ID is not valid';
  }

  String _validatePassword(String value){
    if (value.isEmpty){
      return "Enter your password";
    }
    return null;
  }

  
  Widget _buildUserIdField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: _validateUserId,
      onSaved: (value) {
        this.userId = value;
      },
    );
  }

  Widget _buildPasswordField(){
    return TextFormField(
      obscureText: true,
      keyboardType: TextInputType.text,
      validator: _validatePassword,
      onSaved: (value) {
        this.password = value;
      },
    );
  }
  Widget _buildSubmitButton(){
    return RaisedButton(
      child: Text("Login"),
      onPressed: () {
        if(_signUpKey.currentState.validate()){
          print("validation completed");
        }
      },   
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Form(
            autovalidate: true,
            key: _signUpKey,
            child: Column(
              children: <Widget>[
                _buildUserIdField(),
                _buildPasswordField(),
                Padding(padding: EdgeInsets.all(5),),
                _buildSubmitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
