
class Light {
  int _id;
  int _roomId;
  String _name;
  String _status;

  Light(int roomId, String name, String status) {
    this._roomId = roomId;
    this._name = name;
    this._status = status;
  }

  Light.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._status = obj['status'];
    this._roomId = obj['roomId'];
  }

  int get id => _id;
  int get roomId => _roomId;
  String get name => _name;
  String get status => _status;

  set roomId(int roomId) {
    this._roomId = roomId;
  }

  set name(String name) {
    this._name = name;
  }

  set status(String status) {
    this._status= status;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['roomId'] = _roomId;
    map['name'] = _name;
    map['status'] = _status;
    return map;
  }

  Light.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._roomId = map['roomId'];
    this._name = map['name'];
    this._status = map['status'];
  }
}
