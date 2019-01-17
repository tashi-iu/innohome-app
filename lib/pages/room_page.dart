import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../util/database_helper.dart';
import '../util/mqtt_util.dart';
import '../widgets/light_switch_icon.dart';

import '../scoped_model/scoped_room.dart';

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

  Widget _buildLightSwitches(int roomId) {
    
    return ScopedModelDescendant<RoomModel>(
      builder: (context, child, model){
        return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: widget.lights.length,
        itemBuilder: (context, index) {
          //print(index);
          
          String label = widget.lights[index]["name"];
          int id = index + 1;
          return LightSwitchIcon(
            label: label,
            id: id,
            roomId: roomId,
          );
        });

      },
    );
    
    
    
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RoomModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  model.mqtt.checkMqttConnectionLocal();
                },
              )
            ],
            title: Text(widget.roomName, style: TextStyle(color: Colors.white)),
          ),
          body: _buildLightSwitches(widget.roomId),
        );
      },
    );
  }
}
