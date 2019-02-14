import 'dart:io';
import 'dart:async';

import 'package:smart_switch_v2/pages/house_page.dart';
import 'package:smart_switch_v2/util/light_utils.dart';

import '../util/database_helper.dart';
import '../model/room.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AddRoom extends StatefulWidget {
  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _roomNameController;
  TextEditingController _noOfLightController;
  TextEditingController _roomIdController;
  
  int _roomId;
  int _noOfRooms;
  String _roomName = 'New Room';
  File _roomImage;

  var db = DatabaseHelper();

  @override
  void initState() {
    _roomNameController = TextEditingController();
    _noOfLightController = TextEditingController();
    _roomIdController = TextEditingController();
    super.initState();
  }

  //function to get image
  Future getImage(bool camera) async {
    var image = await ImagePicker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 500,
        maxWidth: 500);

    setState(() {
      _roomImage = image;
    });
  }

  Widget _buildNoOfRoomsTextField() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _noOfLightController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Number of lights',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "Make sure you entered the number of lights in your room";
          }
        },
      ),
    );
  }

  Widget _buildRoomIdTextField(){
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _roomIdController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Room ID',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "This field is mandatory";
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Add Room",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                if (_formKey.currentState.validate() && _roomImage != null) {
                  setState(() {
                    _roomId = num.parse(_roomIdController.text);
                    _roomName = _roomNameController.text;
                    _noOfRooms = num.parse(_noOfLightController.text);
                  });

                  Room oldRoom = await db.getRoom(_roomId);
                  
                  if(oldRoom != null){
                    //pop up error saying roomid is already registered
                    print("bro room is gone");
                    return; 
                  }else{


                  Room room = Room( _roomId, _roomName, _roomImage, _noOfRooms);
                  
                  int res = await db.saveRoom(room);
                  
                  // List _rooms = await db.getAllRooms();

                  // // print("heyyyyyyy");
                  // // _rooms.forEach((room){
                  // //   print("rooming");
                  // //   print(room);
                  // //   print("...........");
                  // // });
                  // // print('this is the room i need bitch ');
                  // print("${_rooms.last['id']}");

                  generatelightsAndSaveToDb(_roomId);
                  if (res != 0) {
                    Navigator.pushReplacementNamed(context, '/rooms');
                  }
                }}
              },
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _roomNameController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        pickCamera();
                      },
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Room Name',
                    hintText: "Childrens' Bedroom",
                  ),
                  validator: (value) {
                    if (value.isEmpty || _roomImage == null) {
                      return "Make sure you entered both the name and image of the room";
                    }
                  },
                ),
              ),
              _buildRoomIdTextField(),
              _buildNoOfRoomsTextField(),
              Padding(
                padding: EdgeInsets.all(_roomImage == null ? 32 : 0),
              ),
              Container(
                child: _roomImage != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4)
                            ),
                            width: double.infinity,
                            height: 225,
                            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            padding: EdgeInsets.all(2),
                            child: Image.file(
                              _roomImage,
                              fit: BoxFit.cover,
                              
                            ),
                          ),
                        ],
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            pickCamera();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.image,
                                size: 64.0,
                                color: Colors.grey,
                              ),
                              Text("No background image selected",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                      fontSize: 16.0)),
                              Text(
                                  "Click on the camera icon or tap here to upload an image",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 14.0)),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ));
  }

  pickCamera() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.camera),
                title: new Text('Camera'),
                onTap: () {
                  getImage(true);
                },
              ),
              new ListTile(
                leading: new Icon(Icons.photo_album),
                title: new Text('Gallery'),
                onTap: () {
                  getImage(false);
                },
              ),
            ],
          );
        });
  }
}
