import 'package:flutter/material.dart';
import '../util/network_util.dart';

class RoomSwitch extends StatefulWidget {
  RoomSwitch({Key key, this.roomName, this.title, this.toggle}) : super(key: key);
  final String roomName;
  final String title;
  bool toggle;

  @override
  _RoomSwitchState createState() => _RoomSwitchState();
}

class _RoomSwitchState extends State<RoomSwitch> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        SwitchListTile(
          title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),),
          value: widget.toggle,
          onChanged: (bool value) {
            setState(() {
              widget.toggle = value;
              //postData(widget.roomName, widget.title, widget.toggle.toString());
            });
          },          //         model.mqtt.checkMqttConnectionLocal();
        ),
      ],
    );
  }
}
