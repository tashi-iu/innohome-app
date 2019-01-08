import 'package:flutter/material.dart';

import '../util/network_util.dart';
import '../util/database_helper.dart';

import '../model/user.dart';

import '../pages/house_page.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  final _signUpKey = GlobalKey<FormState>();

  String email;
  String password;
  String deviceId;
  String username;
  int noOfRooms;

  var db = new DatabaseHelper();

  TextEditingController _passwordController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    super.initState();
  }

  String _validateUsername(String value) {
    if (value.isEmpty) {
      return "Enter user name";
    }
    if (value.length < 5) {
      return "Minimum length for user name is 5";
    }

    String p = "[A-Za-z0-9]";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }

    return 'User name is not valid';
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

  String _validateNoOfRooms(String value) {
    if (value.isEmpty) {
      return "Number of rooms cannot be empty";
    }
    return null;
  }

  String _validateDeviceId(String value) {
    if (value.isEmpty) {
      return "Number of rooms cannot be empty";
    }

    if (value.length < 5) {
      return "Length of device Id shoud be greater than 5";
    }
    return null;
  }

  String _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return "Enter your password again";
    }
    if (value != _passwordController.text) {
      return "Your password does not match";
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "Enter your new password";
    }
    if (value.length < 7) {
      return "Minimum password length is 7";
    }
    return null;
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(hintText: "email"),
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      onSaved: (value) {
        this.email = value;
      },
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      decoration: InputDecoration(hintText: "username"),
      keyboardType: TextInputType.emailAddress,
      validator: _validateUsername,
      onSaved: (value) {
        this.username = value;
      },
    );
  }

  Widget _buildNumberOfRoomsField() {
    return TextFormField(
        decoration: InputDecoration(hintText: "Number of rooms"),
        keyboardType: TextInputType.number,
        validator: _validateNoOfRooms,
        onSaved: (value) {
          this.noOfRooms = num.parse(value);
        });
  }

  Widget _buildDeviceIdField() {
    return TextFormField(
        decoration: InputDecoration(hintText: "Enter device Id"),
        validator: _validateDeviceId,
        onSaved: (value) {
          this.deviceId = value;
        });
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(hintText: "password"),
      controller: _passwordController,
      obscureText: true,
      keyboardType: TextInputType.text,
      validator: _validatePassword,
      onSaved: (value) {
        this.password = value;
      },
    );
  }

  Widget _buildPasswordConirmField() {
    return TextFormField(
        decoration: InputDecoration(hintText: "confirm password"),
        obscureText: true,
        keyboardType: TextInputType.text,
        validator: _validateConfirmPassword);
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      child: Text("Sign up"),
      onPressed: () async {
        if (_signUpKey.currentState.validate()) {
          _signUpKey.currentState.save();
          Map<String, String> response =
              await signUp(email, username, deviceId, noOfRooms, password);

          String error_message = response["error_message"];
          String x_auth = response["x_auth"];
          
          if (error_message == "null" && x_auth == "null") {
            print("oops sth is very wrong");
          } else if (x_auth == "null") {
            print(error_message);
            print("hello from error");
          } else if (error_message == "null") {
            print(response["x_auth"]);
            User user = User(response["x_auth"]);
            int result = await db.saveUser(user);
            if(result > 0){
              print("user is saved");  
            }
          }
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
                _buildUsernameField(),
                _buildNumberOfRoomsField(),
                _buildDeviceIdField(),
                _buildPasswordField(),
                _buildPasswordConirmField(),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                _buildSubmitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
