import 'dart:io';
import 'dart:async';

import 'package:smart_switch_v2/pages/room_page.dart';

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

  int _houseId = 1;
  String _roomName = 'New Room';
  File _roomImage;

  var db = DatabaseHelper();

  @override
  void initState() {
    _roomNameController = TextEditingController();
    super.initState();
  }

  //function to get image
  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 500, maxWidth: 500);

    setState(() {
      _roomImage = image;
    });
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
                    _roomName = _roomNameController.text;
                  });

                  Room room = Room(_houseId, _roomName, _roomImage);
                  int res = await db.saveRoom(room);
                  if (res != 0) {
                    Navigator.pushReplacementNamed(context, '/rooms');
                  }
                }
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
                        getImage();
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
              Padding(padding: EdgeInsets.all(32),),
              Container(
                child: _roomImage != null
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Container(
                        color: Colors.black54,
                      margin: EdgeInsets.all(62),
                      padding: EdgeInsets.all(2),
                      child: Image.file(_roomImage,),
                    ),],
                    )
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            getImage();
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
}
