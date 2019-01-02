import 'package:flutter/material.dart';
import 'package:smart_switch_v2/pages/house_page.dart';
import 'package:scoped_model/scoped_model.dart';

import './util/database_helper.dart';

import './scoped_model/scoped_room.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

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
          home: HousePage(model: _roomModel,),
          routes: {
            '/rooms': (BuildContext context) => HousePage(model: _roomModel),
          },
        ));
  }
}
