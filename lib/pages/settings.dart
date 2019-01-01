import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../util/database_helper.dart';
import '../model/house.dart';

import '../pages/add_room_page.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var db = DatabaseHelper();
  String houseName = 'New House';
  TextEditingController houseNameController;

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 200, maxWidth: 300);
    
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    houseNameController = TextEditingController();
    super.initState();
  }

  //ui elements start here
  Widget _buildHouseSaveButton() {
    return FlatButton(
      child: Text("update"),
      color: Colors.greenAccent,
      onPressed: () async {
        String houseName = houseNameController.text;

        setState(() {
          this.houseName = houseName;
        });
        House houseResult = await db.getHouse(1);

        if (houseResult == null) {
          House house = House(houseName);
          int result = await db.saveHouse(house);
          if (result != null) Navigator.pop(context);
        } else {
          houseResult.houseName = houseName;
          int res = await db.updateHouse(houseResult);
          if (res != null) Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildHouseCancelButton() {
    return FlatButton(
      child: Text("cancel"),
      color: Colors.redAccent,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildHouseSetting() {
    return ListTile(
      onTap: () {
        showDialog(
            builder: (context) {
              return Dialog(
                child: Container(
                  height: 100,
                  width: 150,
                  child: ListView(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Update house name.",
                        ),
                        controller: houseNameController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildHouseCancelButton(),
                          _buildHouseSaveButton(),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            context: context);
      },
      title: Text("Change house name."),
      subtitle: Text(this.houseName),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          print("Changing house name");
        },
      ),
    );
  }

  Widget _buildRoomSetting() {
    return ListTile(
      title: Text("Add room"),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => AddRoom()
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings", style: TextStyle(color: Colors.white),),
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView(
        children: <Widget>[
          _buildHouseSetting(),
          Divider(),
          _buildRoomSetting(),
        ],
      ),
    );
  }
}
