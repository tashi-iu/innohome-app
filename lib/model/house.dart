class House{
  int _houseId;
  String _houseName;

  House(this._houseName);


  House.map(dynamic obj){
    this._houseName = obj['username'];
    this._houseId = obj['id'];
  }

  String get houseName => _houseName;
  int get id => _houseId;

  set houseName(String houseName){
    this._houseName = houseName;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["houseName"] = _houseName;

    if(_houseId != null){
      map["id"] = _houseId;
    }

    return map;
  }

  House.fromMap(Map<String, dynamic> map) {
    this._houseName = map["houseName"];
    this._houseId = map["id"];
  }
}