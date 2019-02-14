import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class Room {
  int _id;
  int _houseId = 1;
  int _noOfLights;
  String _roomName;
  Uint8List _roomImage;

  Room(int roomId, String roomName, File roomImage, int noOfLights) {
    this._id = roomId;
    this._roomName = roomName;
    this._roomImage = roomImage.readAsBytesSync();
    this._noOfLights = noOfLights;
  }

  Room.map(dynamic obj) {
    this._id = obj['id'];
    this._roomName = obj['roomName'];
    this._roomImage = base64.decode(obj['roomImage']);
    this._houseId = obj['houseId'];
    this._noOfLights = obj['noOfLights'];
  }

  int get id => _id;
  int get houseId => _houseId;
  int get noOfLights => _noOfLights;
  String get roomName => _roomName;
  Uint8List get roomImage => _roomImage;

  set houseId(int houseId) {
    this._houseId = houseId;
  }

  set roomName(String roomName) {
    this._roomName = roomName;
  }

  set roomImage(Uint8List image) {
    this._roomImage = image;
  }
  set roomId(int id){
    this.roomId = id;
  }

  set noOfLights(int noOfLights){
    this._noOfLights = noOfLights;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['houseId'] = _houseId;
    map['roomName'] = _roomName;
    map['noOfLights'] = _noOfLights;
    map['roomImage'] = base64.encode(_roomImage);
    return map;
  }

  Room.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._houseId = map['houseId'];
    this._roomName = map['roomName'];
    this._noOfLights = map['noOfLights'];
    this._roomImage = base64.decode(map['roomImage']);
  }
}
