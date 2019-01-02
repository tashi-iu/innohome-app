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
      child: Text(
        "Okay",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.cyan,
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
      child: Text("Cancel",
          style: TextStyle(
            color: Colors.red.shade900,
          )),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    height: 200,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text("Rename House",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.black.withOpacity(0.7))),
                        ),
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "e.g. Dorji Family",
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
        title: Text("Change house name"),
        subtitle: Text(this.houseName.isEmpty
            ? "House name not provided"
            : this.houseName),
        leading: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(
            Icons.home,
            color: Colors.cyan,
          ),
        ));
  }

  Widget _buildRoomSetting() {
    return ListTile(
      title: Text("Add room"),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddRoom()));
      },
      leading: Padding(
        child: Icon(
          Icons.border_all,
          color: Colors.cyan,
        ),
        padding: EdgeInsets.only(left: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
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
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider()),
          _buildRoomSetting(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider()),
        ],
      ),
    );
  }
}
