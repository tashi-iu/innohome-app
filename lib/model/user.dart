class User{
  int _userId;
  String _userToken;
  String _deviceId;

  User(this._userToken, this._deviceId);


  User.map(dynamic obj){
    this._userToken = obj['userToken'];
    this._userId = obj['id'];
    this._deviceId = obj['deviceId'];
  }

  String get userToken => _userToken;
  int get id => _userId;
  
  set userToken(String token){
    this._userToken = token;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["userToken"] = _userToken;
    map["deviceId"] = _deviceId;

    if(_userId != null){
      map["id"] = _userId;
    }

    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._userId = map["id"];
    this._userToken = map["userToken"];
    this._deviceId = map["deviceId"];
  }
}