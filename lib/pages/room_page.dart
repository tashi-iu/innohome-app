import 'package:flutter/material.dart';
import 'package:smart_switch_v2/pages/settings.dart';
import 'package:scoped_model/scoped_model.dart';

import '../util/database_helper.dart';

import '../scoped_model/scoped_room.dart';

import '../model/room.dart';

class RoomPage extends StatefulWidget {
  final RoomModel model;
  RoomPage({this.model});

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  var db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    widget.model.getRooms();
  }

  Widget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      title: Text(
        "Rooms",
        style: TextStyle(color: Colors.white, ),
      ),
      actions: <Widget>[
        IconButton(
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
                "This is innoHome, we are the leading provider of smart switch in Bhutan."),
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
            margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 1.0,
                    offset: Offset(1,1),
                  )],
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(image: MemoryImage(room.roomImage), fit: BoxFit.cover,)
              ),
              child: Container(
                padding: EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Center(child:Text(room.roomName, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withAlpha(230), fontWeight: FontWeight.w600, fontSize: 18.0,  ),),),)//Image.memory(room.roomImage),
            
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/bg.jpg",))
        ),
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, RoomModel model) {
        return GridView.count(
          padding: EdgeInsets.fromLTRB(4,8,4,4),
            crossAxisCount: 2,
            children: List.generate(
                widget.model.length != null ? widget.model.length : 0, (index) {
              print(widget.model.length);
              return buildRoomCard(index);
            }));
      }),
      ),
    );
  }
}
