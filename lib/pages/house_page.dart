import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smart_switch_v2/pages/landing_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wifi/wifi.dart';

import './room_page.dart';
import '../model/room.dart';
import '../scoped_model/scoped_room.dart';
import '../util/database_helper.dart';
import 'about_page.dart';
import 'add_room_page.dart';
import 'help_page.dart';
import 'landing_page.dart';

class HousePage extends StatefulWidget {
  final RoomModel model;
  HousePage({this.model});

  @override
  _HousePageState createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  var db = DatabaseHelper();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool connected = false;
  @override
  void initState(){
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
          onPressed: () async {
            setState(() {
              widget.model.local = !widget.model.local;
              widget.model.mqttState = false;
            });
            if (widget.model.local) {
              String _ssid = await Wifi.ssid;
              if (_ssid.toLowerCase().contains("innohome")) {
                setState(() {
                  connected = true;
                });
              } else {
                setState(() {
                  connected = false;
                });
              }
              if (!connected) {
                _showLocalWifiDialog();
              }
            } else {
              String _ssid = await Wifi.ssid;
              if (_ssid.toLowerCase().contains("innohome")) {
                _showInternetDialog();
              } else
                showInSnackBar("Switched to internet connection");
            }
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
        children: <Widget>[
          ListTile(
            title: Text("Help",),
            leading: Icon(Icons.help),
            onTap: () {
              Navigator.push(this.context,
                  MaterialPageRoute(builder: (context) => HelpPage()));
            },
          ),
          ListTile(
            title: Text("About Us"),
            leading: Icon(Icons.people),
            onTap: () {
              Navigator.push(this.context,
                  MaterialPageRoute(builder: (context) => AboutPage()));
            },
          ),
          ListTile(
            title: Text("Log Out"),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              int res1 = await db.deleteAllUser();
              int res2 = await db.deleteAllHouse();
              int res3 =await db.deleteAllRoom();
              int res4 = await db.deleteAllLight();

              print("$res1, $res2, $res3, $res4");

              if(res1 != 0){
              Navigator.pushReplacement(this.context,
                  MaterialPageRoute(builder: (context) => LandingPage()));
            }else{
              print("error logging out");
            }},
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
      Room room = model.getRoomFromList(index);

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            List<Map<String, dynamic>> lights = await db.getAllLights(room.id);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => RoomPage(
                        room.id, room.roomName, room.roomImage, lights)));
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Add Room",
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRoom(),
            ),
          );
        },
      ),
      // bottomNavigationBar: ScopedModelDescendant<RoomModel>(
      //   builder: (context, child, model) {
      //     if (model.local) {
      //       return InkWell(
      //         child: Container(
      //           height: 48,
      //           color: model.mqttState ? Colors.cyan : Colors.red,
      //           child: Center(
      //             child: model.mqttStateChecking
      //                 ? LinearProgressIndicator()
      //                 : Text(
      //                     model.mqttState
      //                         ? "Connection Established"
      //                         : "You are not connected. Tap here to connect",
      //                     style: TextStyle(
      //                         fontSize: 14,
      //                         color: Colors.white.withOpacity(0.85)),
      //                   ),
      //           ),
      //         ),
      //         onTap: () {
      //           if (!model.mqttState) {
      //             setState(() {
      //               model.mqttStateChecking = true;
      //             });
      //             model.mqtt.checkMqttConnectionLocal();
      //             setState(() {
      //               model.mqttStateChecking = false;
      //               model.mqttState = true;
      //             });
      //           } else {
      //             setState(() {
      //               model.mqttState = false;
      //             });
      //             print("MQTT OFF");
      //           }
      //         },
      //       );
      //     }
      //     return Visibility(
      //       visible: false,
      //       child: Container(
      //         height: 1,
      //       ),
      //     );
      //   },
      // ),
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

  void _showLocalWifiDialog() {
    showDialog(
        barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "You don't seem to be connected. Please connect to the InnoHome wifi network and try again",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ScopedModelDescendant<RoomModel>(
                  builder: (BuildContext context, Widget child, Model model) {
                    return ListTile(
                      title: Text(
                        "Try again",
                        style: TextStyle(color: Colors.cyan),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () async {
                        String _ssid = await Wifi.ssid;
                        if (_ssid.toLowerCase().contains("innohome")) {
                          setState(() {
                            widget.model.local = true;
                            connected = true;
                          });
                          widget.model.mqtt.checkMqttConnectionLocal();
                          showInSnackBar("Switched to local network");
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                ),

                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: this.wifiList.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     if (wifiList.length == 0) {
                //       return Container(
                //         child: Text(
                //             "innoHome WiFi network seems to be out of range"),
                //       );
                //     }
                //     String innoWifi = wifiList[index].ssid;
                //     if (innoWifi.toLowerCase().contains("inno") == true) {
                //       return ExpansionTile(
                //         leading: Icon(Icons.wifi),
                //         title: Text(wifiList[index].ssid),
                //         children: <Widget>[
                //           LoginInputTextField(
                //             labelText: "Password",
                //             obscureText: true,
                //             controller: _wifiPasswordCtrl,
                //           ),
                //           ListTile(
                //             title: Text(
                //               "Connect",
                //               textAlign: TextAlign.center,
                //             ),
                //             onTap: () {
                //               print(innoWifi);
                //               print(_wifiPasswordCtrl.text);

                //               Wifi.connection(innoWifi, _wifiPasswordCtrl.text)
                //                   .then((v) {
                //                 print(v);
                //               });
                //             },
                //           )
                //         ],
                //       );
                //     }
                //   },
                // ),
                Divider(),
                ScopedModelDescendant<RoomModel>(
                  builder:
                      (BuildContext context, Widget child, RoomModel model) {
                    return ListTile(
                        title: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            widget.model.local = false;
                            connected = false;
                          });
                          showInSnackBar("Switched to internet connection");
                          Navigator.pop(context);
                        });
                  },
                ),
              ],
            ),
          );
        });
  }

  void _showInternetDialog() {
    showDialog(
        barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "You seem to be connected to the innoHome network. Please connect to the internet and try again",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Divider(),
                ScopedModelDescendant<RoomModel>(
                  builder: (BuildContext context, Widget child, Model model) {
                    return ListTile(
                      title: Text(
                        "Try again",
                        style: TextStyle(color: Colors.cyan),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () async {
                        String _ssid = await Wifi.ssid;
                        if (_ssid.toLowerCase().contains("innohome")) {
                          setState(() {
                            widget.model.local = true;
                            connected = true;
                          });
                          showInSnackBar("Switched to Local Network");
                        } else {
                          setState(() {
                            widget.model.local = false;
                            connected = false;
                          });
                          showInSnackBar("Switched to Internet Connection");
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                ),
                Divider(),
                ScopedModelDescendant<RoomModel>(
                  builder:
                      (BuildContext context, Widget child, RoomModel model) {
                    return ListTile(
                      title: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          widget.model.local = true;
                          connected = true;
                        });
                        showInSnackBar("Switched to local network.");
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
                Divider()
              ],
            ),
          );
        });
  }
}
