import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:smart_switch_v2/model/light.dart';
import 'package:smart_switch_v2/model/room.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../model/house.dart';
import '../model/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableUser = "userTable";
  final String columnUserId = "id";
  final String columnUserToken = "userToken";
  final String columnDeviceId = "deviceId";

  final String tableHouse = "houseTable";
  final String columnHouseId = "id";
  final String columnHouseName = "houseName";

  final String tableRoom = "roomTable";  
  final String columnRoomId = "id";
  final String columnRoomName = "roomName";
  final String columnRoomImage = "roomImage";
  final String columnNoOfLights = "noOfLights";
  final String columnForeignHouseId = "houseId";

  final String tableLight = "lightTable";
  final String columnLightId = "id";
  final String columnLightName = "name";
  final String columnForeignRoomId = "roomId";
  final String columnLightStatus = "status";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "smartSwitch.db");

    var smartSwitchDb =
        await openDatabase(path, version: 1, onCreate: _onCreate);
    return smartSwitchDb;
  }

  void _onCreate(Database db, int vesion) async {
      await db.execute("""
            CREATE TABLE $tableUser(
              $columnUserId INTEGER PRIMARY KEY NOT NULL,
              $columnUserToken TEXT,
              $columnDeviceId TEXT NOT NULL
            )""");
      
      await db.execute("""
            CREATE TABLE $tableHouse(
              $columnHouseId INTEGER PRIMARY KEY,
              $columnHouseName TEXT NOT NULL 
            )""");

    await db.execute("""
      CREATE TABLE $tableRoom(
        $columnRoomId INTEGER PRIMARY KEY,
        $columnRoomName TEXT NOT NULL,
        $columnRoomImage TEXT NOT NUll,
        $columnNoOfLights INTEGER NOT NULL,
        $columnForeignHouseId INTEGER NOT NULL,
        FOREIGN KEY ($columnForeignHouseId) REFERENCES $tableHouse ($columnHouseId)
      )
      """);

    await db.execute("""
      CREATE TABLE $tableLight(
        $columnLightId INTEGER PRIMARY KEY,
        $columnLightStatus TEXT NOT NULL,
        $columnForeignRoomId INTEGER NOT NULL,
        $columnLightName TEXT,
        FOREIGN KEY ($columnForeignRoomId) REFERENCES $tableHouse ($columnHouseId)
      )
      """);
  }


  //USER ORM
  Future<int> saveUser(User user) async {
    var dbClient = await db;

    int res = await dbClient.insert("$tableUser", user.toMap());
    return res;
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;

    int res = await dbClient.update(tableUser, user.toMap(), where: "$columnUserId = ?", whereArgs: [user.id]);
    return res;
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;

    var result = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE $columnUserId=$id");
    if(result.length == 0) return null;

    return User.fromMap(result.first);
  }

  Future<List> getAllUser() async {
    var dbClient = await db;

    var result = await dbClient.rawQuery("SELECT * FROM $tableUser");
    return result.toList();
  }

  //HOUSE ORM
  Future<int> saveHouse(House house) async {
    var dbClient = await db;

    int res = await dbClient.insert("$tableHouse", house.toMap());
    return res;
  }

  Future<int> updateHouse(House house) async {
    var dbClient = await db;

    int res = await dbClient.update("$tableHouse", house.toMap(),
        where: "$columnHouseId = ?", whereArgs: [house.id]);
    return res;
  }

  //contains no error now
  Future<House> getHouse(int id) async {
    var dbClient = await db;

    var result = await dbClient.rawQuery("SELECT * FROM $tableHouse WHERE $columnHouseId=$id");
    if(result.length == 0) return null;

    return House.fromMap(result.first);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  //Room ORM

  //inserting a room
  Future<int> saveRoom(Room room) async{
    var dbClient = await db;

    var result = await dbClient.insert("$tableRoom", room.toMap());
    return result;    
  }

  //getting all the rooms
  Future<List> getAllRooms() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableRoom");

    return result.toList();
  }

  //getting a room from id
  Future<Room> getRoom(int id) async {
    var dbClient = await db;

    List<Map> result = await dbClient.rawQuery("SELECT * FROM $tableRoom WHERE $columnRoomId=$id");

    if(result.length == 0) return null;

    return Room.fromMap(result.first);
  }

  //updating a room
  Future<int> updateRoom(Room room) async {
    var dbClient = await db;

    return await dbClient.update("$tableRoom", room.toMap(), where: "$columnRoomId = ?", whereArgs: [room.id]);
  }

  //deleting a room
  Future<int> deleteRoom(int id) async {
    var dbClient = await db;

    return dbClient.delete(tableRoom, where: "$columnRoomId = ?", whereArgs: [id]);
  }

  //light orm
  //inserting a light
  Future<int> saveLight(Light light) async{
    var dbClient = await db;

    var result = await dbClient.insert("$tableLight", light.toMap());
    return result;    
  }

  //getting all the lights
  Future<List> getAllLights(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableLight WHERE $columnForeignRoomId=$id");

    return result.toList();
  }
  //getting a light from id
  Future<Light> getLight(int id) async {
    var dbClient = await db;

    List<Map> result = await dbClient.rawQuery("SELECT * FROM $tableLight WHERE $columnLightId=$id");

    if(result.length == 0) return null;

    return Light.fromMap(result.first);
  }

  //updating a light
  Future<int> updateLight(Light light) async {
    var dbClient = await db;

    return await dbClient.update("$tableLight", light.toMap(), where: "$columnRoomId = ?", whereArgs: [light.id]);
  }

  //deleting a light
  Future<int> deleteLight(int id) async {
    var dbClient = await db;

    return dbClient.delete(tableLight, where: "$columnLightId = ?", whereArgs: [id]);
  }  
}

