import 'package:flutter/material.dart';
import 'package:smart_switch_v2/pages/settings.dart';
import 'package:scoped_model/scoped_model.dart';

import './room_page.dart';

import '../util/database_helper.dart';
import '../scoped_model/scoped_room.dart';

import '../model/room.dart';

class HousePage extends StatefulWidget {
  final RoomModel model;
  HousePage({this.model});

  @override
  _HousePageState createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  var db = DatabaseHelper();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    widget.model.getRooms();
  }

  Widget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      title: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 4),
            ),
            Text(
              "Rooms",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
              widget.model.local ? Icons.home : Icons.settings_input_antenna),
          onPressed: () {
            setState(() {
              widget.model.local = !widget.model.local;
              widget.model.mqttState = false;
            });
            widget.model.local
                ? showInSnackBar("Switched to local network")
                : showInSnackBar("Switched to internet network");
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
            child: Text("InnoHome"),
          ),
          ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
          // Container(
          //   child: Text(
          //       "This is innoHome, we are the leading provider of smart switch in Bhutan."),
          // )
        ],
      ),
    );
  }

  Widget buildRoomCard(int index) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, RoomModel model) {
      Room room = model.getRoom(index);
      //print(room.toMap());

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            //print(room.toMap());

            List<Map<String, dynamic>> lights = await db.getAllLights(room.id);

            // print("lights are");
            // lights.forEach((light){
            //   print(light);
            // });

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        RoomPage(room.id, room.roomName, lights)));
          },
          child: Hero(
            tag: room.id,
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 1.0,
                    offset: Offset(1, 1),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: MemoryImage(room.roomImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Container(
                    child: Text(
                      room.roomName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withAlpha(230),
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      bottomNavigationBar: ScopedModelDescendant<RoomModel>(
          builder: (context, child, model) {
            if(model.local){
            return InkWell(
              child: Container(
              height: 48,
              color: model.mqttState ? Colors.cyan : Colors.red,
              child: Center(
                child: Text(
                model.mqttState ? "Connection Established"
                    : "You are not connected. Tap here to connect",
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(0.85)),
              ),
              )
            ),
            onTap: () {

              model.mqtt.checkMqttConnectionLocal();
              Future.delayed(Duration(seconds: 2));
              // if(model.mqtt.client.connectionStatus.state.toString() == "MqttConnectionState.connected"){
              //   setState((){model.mqttState = true;});
              // }else{
              //   setState((){model.mqttState = false;});
              // }  
                setState((){model.mqttState = !model.mqttState;});
            },
            );}
          return Text("");    
          },
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/bg.jpg",
            ),
          ),
        ),
        child: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, RoomModel model) {
          return GridView.count(
            padding: EdgeInsets.fromLTRB(4, 8, 4, 4),
            crossAxisCount: 2,
            children: List.generate(
                widget.model.length != null ? widget.model.length : 0, (index) {
              return buildRoomCard(index);
            }),
          );
        }),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }
}
