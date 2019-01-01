import 'dart:io';
import 'dart:async';

import 'package:smart_switch_v2/pages/home_page.dart';

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
  void initState(){

    _roomNameController = TextEditingController();
    super.initState();
  }



  //function to get image
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 500, maxWidth: 500);

    setState(() {
      _roomImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Add room", style: TextStyle(color: Colors.white),),
      ),
      body:Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          TextFormField(
            textAlign: TextAlign.center,
            controller: _roomNameController,
            decoration: InputDecoration(
              labelText: 'Room Name',
              hintText: "Childrens' Bedroom",
            ),
            validator: (value) {
              if (value.isEmpty || _roomImage == null) {
                return "Please enter the name and image of the room";
              }
            },
          ),
          Padding(padding: EdgeInsets.all(5)),
          Column(children: <Widget>[
            Center(
              child: Container(
                  child: _roomImage == null
                      ? RaisedButton(
                          child: Text("add Image"),
                          onPressed: () {
                            getImage();
                          },
                        )
                      : Column(children: <Widget>[Image.file(_roomImage)])),
            ),
            _roomImage != null? RaisedButton(
              child: Text("change image"),
              onPressed: () {
                getImage();
              }, 
            ) : Container(),
            RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate() && _roomImage != null) {
                  setState(() {
                    _roomName = _roomNameController.text;                
                  });

                  Room room = Room(_houseId, _roomName, _roomImage);
                  int res = await db.saveRoom(room);
                  if(res != 0){
                    Navigator.pushReplacementNamed(context, '/rooms');
                  }
                }
              },
              child: Text("Add room"),
            ),
          ])
        ],
      ),
    ));
  }
}
