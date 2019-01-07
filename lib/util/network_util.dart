import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config_api_endpoints.dart';

Future<Map> postData(String room, String switchName, String toggle) async {
  String sourceURL = "http://192.168.128.88:3000/smart-switch/send-data-demo";

  http.Response response = await http.post(sourceURL, body: json.encode({"room":"$room", "switchName":"$switchName", "toggle":"$toggle"}), headers: {"Content-type": "application/json", "Accept": "application/json"});
  return json.decode(response.body);
}

Future<Map> signUp(String email, String username, String deviceId, int noOfRooms, String password) async {
  String sourceURL = signUpEndpoint;

  Map<String, dynamic> body = {
    "email": email,
    "username": username,
    "deviceId": deviceId,
    "noOfRooms": noOfRooms,
    "password": password
  };

  http.Response response = await http.post(sourceURL, body: json.encode(body));
  return json.decode(response.body);
}