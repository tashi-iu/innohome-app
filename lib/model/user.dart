class User{
  int _userId;
  String _userToken;

  User(this._userToken);


  User.map(dynamic obj){
    this._userToken = obj['userToken'];
    this._userId = obj['id'];
  }

  String get userToken => _userToken;

  set userToken(String token){
    this._userToken = token;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["userToken"] = _userToken;

    if(_userId != null){
      map["id"] = _userId;
    }

    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._userId = map["userToken"];
    this._userToken = map["id"];
  }
}