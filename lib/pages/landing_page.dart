import 'package:flutter/material.dart';
import './widgets/room_card.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        children: <Widget>[
          RoomCard(roomName: "Bedroom 1",),
          RoomCard(roomName: "Bedroom 2",),
          RoomCard(roomName: "Bedroom 3",),
          RoomCard(roomName: "Living Room",),
          RoomCard(roomName: "Kitchen",),
          RoomCard(roomName: "Bathroom",),
        ],
      ),
    );
  }
  
}