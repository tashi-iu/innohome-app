import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config_api_endpoints.dart';

Future<Map> postData(String room, String switchName, String toggle, String xAuth) async {
  String sourceURL = "http://192.168.0.111:3000/smart-switch/mainhub";

  Map<String, String> data = {"room":"$room", "switchName":"$switchName", "status":"$toggle"};

  http.Response response = await http.post(sourceURL, body: json.encode(data), headers: {"Content-type": "application/json", "Accept": "application/json", "x-auth": xAuth});
  print(data);
  return data;
}

Future<Map> signUp(String email, String deviceId,
    int noOfRooms, String password) async {
  String sourceURL = signUpEndPoint;

  Map<String, dynamic> body = {
    "email": email,
    "deviceId": deviceId,
    "noOfRooms": noOfRooms,
    "password": password
  };

  try {
    http.Response response = await http.post(sourceURL,
        headers: {'content-type': 'application/json'}, body: json.encode(body));
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, dynamic> responseHeaders = response.headers;

    Map<String, String> obj = {
      "x_auth": "${responseHeaders["x-auth"]}",
      "error_message": "${responseBody["error_message"]}",
    };
    return obj;
  } catch (err) {
    print("no network bahi");
  }

  Map<String, String> obj = {
    "x_auth": "null",
    "error_message": "null",
  };

  return obj;
}

Future<Map> login(String email String password) async {
  String sourceURL = loginEndPoint;

  Map<String, dynamic> body = {
    "email": email,
    "password": password
  };

  try {
    
    http.Response response = await http.post(sourceURL,
        headers: {'content-type': 'application/json'}, body: json.encode(body));
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, dynamic> responseHeaders = response.headers;

    Map<String, String> obj = {
      "x_auth": "${responseHeaders["x-auth"]}",
      "error_message": "${responseBody["error_message"]}",
    };
    return obj;
    
  } catch (err) {
    print("no network bahi");
  }

  Map<String, String> obj = {
    "x_auth": "null",
    "error_message": "null",
  };

  return obj;
}

