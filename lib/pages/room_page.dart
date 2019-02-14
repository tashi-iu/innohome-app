import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../util/database_helper.dart';
import '../widgets/light_switch_icon.dart';

import '../scoped_model/scoped_room.dart';

class RoomPage extends StatefulWidget {
  final int roomId;
  final String roomName;
  final Uint8List roomImage;

  List<Map<String, dynamic>> lights;
  RoomPage(this.roomId, this.roomName, this.roomImage, this.lights);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  var db = DatabaseHelper();

  Widget _buildLightSwitches(int roomId) {
    return ScopedModelDescendant<RoomModel>(
      builder: (context, child, model) {
        return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: widget.lights.length,
            itemBuilder: (context, index) {
              String label = widget.lights[index]["name"];
              return LightSwitchIcon(
                label: label,
                index: index,
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
          // appBar: AppBar(
          //   iconTheme: IconThemeData(color: Colors.white),
          //   actions: <Widget>[
          //     IconButton(
          //       icon: Icon(Icons.refresh),
          //       onPressed: () {
          //         model.mqtt.checkMqttConnectionLocal();
          //       },
          //     ),
          //   ],
          //   title: Text(
          //     widget.roomName,
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       color: Colors.white.withAlpha(230),
          //       fontWeight: FontWeight.w600,
          //       fontSize: 18.0,
          //     ),
          //   ),
          // ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text(
              "Add Light",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {},
          ),
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){
                        _showRoomDialog(widget.roomName, widget.roomId);
                      },
                    )
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      widget.roomName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    background: Hero(
                      tag: widget.roomId,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(widget.roomImage),
                              fit: BoxFit.cover),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: _buildLightSwitches(widget.roomId),
          ),
        );
      },
    );
  }

  void _showRoomDialog(String roomName, int roomId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Are you sure you want to delete the room '$roomName'?",
                  style: TextStyle(fontSize: 42),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      child: Text(
                        "Delete Room",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      onPressed: () async {
                        int res = await db.deleteRoom(roomId);
                        Navigator.pushReplacementNamed(context, "/rooms");

                        // TO DO RINZIN : DELETE ROOM
                      },
                    ),
                    MaterialButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  editRoom() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Delete Room'),
                onTap: () {
                  _showRoomDialog(widget.roomName, widget.roomId);
                },
              ),
            ],
          );
        });
  }
}
