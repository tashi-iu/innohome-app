import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _signUpKey = GlobalKey<FormState>();

  String email;
  String password;
  String deviceId;
  String userId;

  TextEditingController _passwordController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    super.initState();
  }

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
      return "Enter your new password";
    }
    if(value.length < 7){
      return "Minimum password length is 7";
    }
    return null;
  }

  String _validateConfirmPassword(String value){
    if(value.isEmpty){
      "Enter your password again";
    }
    if(value != _passwordController.text){
      "Your password does not match";
    }
    return null;
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
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

  Widget _buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      onSaved: (value) {
        this.email = value;
      },
    );
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
      controller: _passwordController,
      obscureText: true,
      keyboardType: TextInputType.text,
      validator: _validatePassword,
      onSaved: (value) {
        this.password = value;
      },
    );
  }

  Widget _buildPasswordConirmField(){
    return TextFormField(
      obscureText: true,
      keyboardType: TextInputType.text,
      validator: _validateConfirmPassword
    );
  }

  Widget _buildSubmitButton(){
    return RaisedButton(
      child: Text("Sign up"),
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
                _buildEmailField(),
                _buildUserIdField(),
                _buildUserIdField(),
                _buildPasswordField(),
                _buildPasswordConirmField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
