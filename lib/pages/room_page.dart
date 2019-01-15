import 'package:flutter/material.dart';

import '../util/database_helper.dart';

import '../widgets/light_switch_icon.dart';

import '../model/light.dart';

class RoomPage extends StatefulWidget {
  final int roomId;
  final String roomName;
  List<Map<String, dynamic>> lights;
  RoomPage(this.roomId, this.roomName, this.lights);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  var db = DatabaseHelper();

  Widget _buildLightSwitches(){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: widget.lights.length,
      itemBuilder: (context, index){
        print(index);
        String label = widget.lights[index]["name"];
        int id = widget.lights[index]["id"];

        return LightSwitchIcon(label: label, id: id);
         
        } );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
      ),
      body: _buildLightSwitches(),
    );
  }
}
