import 'package:flutter/material.dart';
import './widgets/room_switch.dart';

class RoomPage extends StatelessWidget {
RoomPage({Key key, this.roomName}) : super(key: key);

  final String roomName;

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(roomName),
        ),
        body: Column(
          children: <Widget>[
            RoomSwitch(roomName: roomName, title: "Lights D1", toggle: false,),
            RoomSwitch(roomName: roomName, title: "Lights D2", toggle: false,),
            RoomSwitch(roomName: roomName, title: "Lights D3", toggle: false,),
            RoomSwitch(roomName: roomName, title: "Lights D4", toggle: false,),
            Divider()
          ],
        ),
      );
    }
}