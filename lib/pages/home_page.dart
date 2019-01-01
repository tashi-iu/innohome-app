import 'package:flutter/material.dart';
import 'package:smart_switch_v2/pages/settings.dart';
import 'package:scoped_model/scoped_model.dart';

import '../util/database_helper.dart';

import '../scoped_model/scoped_room.dart';

import '../model/room.dart';

class Home extends StatefulWidget {
  final RoomModel model;
  Home({this.model});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    widget.model.getRooms();
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        "Rooms",
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings()));
          },
        )
      ],
    );
  }

  //ui elements start here
  Widget _buildDrawer() {
    return Drawer(
      elevation: 1,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: ListView(
              children: <Widget>[
                Text("innoHome"),
              ],
            ),
          ),
          Container(
            child: Text(
                "This is innoHome, we are the leading privider of smart Switch in Bhutan."),
          )
        ],
      ),
    );
  }

  Widget buildRoomCard(int index) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, RoomModel model) {
        Room room = model.getRoom(index);
        return 
          Container(
            margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(image: MemoryImage(room.roomImage), fit: BoxFit.cover)
              ),
              child: Text(room.roomName)//Image.memory(room.roomImage),
            
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, RoomModel model) {
        return GridView.count(
            crossAxisCount: 2,
            children: List.generate(
                widget.model.length != null ? widget.model.length : 0, (index) {
              print(widget.model.length);
              return buildRoomCard(index);
            }));
      }),
    );
  }
}
