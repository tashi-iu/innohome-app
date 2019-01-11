import 'package:flutter/material.dart';
import 'package:smart_switch_v2/util/database_helper.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/landing_page.dart';
import './pages/house_page.dart';
import './pages/signup_page.dart';
import './pages/login_page.dart';

import './scoped_model/scoped_room.dart';

import './model/user.dart';

void main() async{
  print("this is main");
  var db = DatabaseHelper();

  User user = await db.getUser(1);
  print("user is $user");

  Map<String, dynamic> userObj;
  if(user != null){
    userObj = {
      "id": user.id,
      "token": user.userToken
    };
  }else{
    userObj = {
      "id": null,
      "token": null
    };
    
  }

  print("user object is $userObj");

  runApp(MyApp(userObj));
}

class MyApp extends StatelessWidget {

  Map<String, dynamic> user;
  MyApp(this.user);

  final _roomModel = RoomModel();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<RoomModel>(
        model: _roomModel,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'innoHome',
          theme: ThemeData(
            primarySwatch: Colors.cyan,
          ),
          home:  this.user["token"] != null? HousePage(model: _roomModel,): LandingPage(),
          routes: {
            '/rooms': (BuildContext context) => HousePage(model: _roomModel),
            '/signup': (BuildContext context) => SignUpPage(),
            '/login': (BuildContext context) => LoginPage()         
          },
        ));
  }
}
