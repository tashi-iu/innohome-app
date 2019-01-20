import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_model/scoped_room.dart';

import '../util/mqtt_util.dart';
import '../util/network_util.dart';

import '../model/user.dart';
import '../util/database_helper.dart';

class LightSwitchIcon extends StatefulWidget {
  final String label;
  final int id;
  final int roomId;

  LightSwitchIcon(
      {Key key, @required this.label, @required this.id, @required this.roomId})
      : super(key: key);

  @override
  _LightSwitchState createState() => _LightSwitchState();
}

class _LightSwitchState extends State<LightSwitchIcon> {
  bool _toggle = false;
  
  @override
  Widget build(BuildContext context) {
    
    return ScopedModelDescendant<RoomModel>(builder: (context, child, model) {
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.cyan.withOpacity(0.1),
        // highlightColor: Colors.transparent,
        onTap: () async {
          setState(() {
            _toggle = !_toggle;
          });
          if (model.local) {
            model.mqtt.postData(
                "r${widget.roomId}", "D${widget.id}", _toggle ? "ON" : "OFF");
          } else {
            var db = DatabaseHelper();
            User user = await db.getUser(1);
          postData(
                 "r${widget.roomId}", "D${widget.id}", _toggle ? "ON" : "OFF", user.userToken);
          }
        },
        child: Container(
          height: 80,
          width: 80,
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: _toggle ? Colors.cyan : Colors.grey),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: _toggle ? Colors.cyan : Colors.grey,
                  size: 40.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
              ),
              Text(widget.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 0.7,
                  )),
            ],
          ),
        ),
      );
    });
  }
}
