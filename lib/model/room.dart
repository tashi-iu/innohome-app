import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class Room {
  int _id;
  int _houseId = 1;
  String _roomName;
  Uint8List _roomImage;

  Room(int houseId, String roomName, File roomImage) {
    this._houseId = houseId;
    this._roomName = roomName;
    this._roomImage = roomImage.readAsBytesSync();
  }

  Room.map(dynamic obj) {
    this._id = obj['id'];
    this._roomName = obj['roomName'];
    this._roomImage = base64.decode(obj['roomImage']);
    this._houseId = obj['houseId'];
  }

  int get id => _id;
  int get houseId => _houseId;
  String get roomName => _roomName;
  Uint8List get roomImage => _roomImage;

  set HouseId(int houseId) {
    this._houseId = houseId;
  }

  set roomName(String roomName) {
    this._roomName = roomName;
  }

  set roomImage(Uint8List image) {
    this._roomImage = image;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['houseId'] = _houseId;
    map['roomName'] = _roomName;
    map['roomImage'] = base64.encode(_roomImage);
    return map;
  }

  Room.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._houseId = map['houseId'];
    this._roomName = map['roomName'];
    this._roomImage = base64.decode(map['roomName']);
  }
}
