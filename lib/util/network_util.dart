import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config_api_endpoints.dart';

Future<Map> postData(String room, String switchName, String toggle, String xAuth) async {
  String sourceURL = postDataEndPoint;

  Map<String, String> data = {"room":"$room", "switchName":"$switchName", "status":"$toggle"};
  
  http.Response response = await http.post(sourceURL, body: json.encode(data), headers: {"Content-type": "application/json", "Accept": "application/json", "x-auth": xAuth});
  print(data);
  return data;
}


//user signs up and get verification code.
Future<Map> signUp(String phone, String deviceId) async {
  String sourceURL = signUpEndPoint;

  Map<String, dynamic> body = {
    "phoneNumber": "$phone",
    "deviceId": "$deviceId",
  };

  try {
    http.Response response = await http.post(sourceURL,
        headers: {'content-type': 'application/json'}, body: json.encode(body));
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, String> obj = {
      "type": "${responseBody["type"]}",
      "message": "${responseBody["message"]}",
    };
    return obj;

  } catch (err) {
    print("no network bahi");
  }

  Map<String, String> obj = {
    "message": "null",
    "type": "null",
  };

  return obj;
}

// Sign up verification
Future<Map> verifySignUp(String phone, String code) async {
  String sourceURL = verifySignUpEndPoint;

  Map<String, dynamic> body = {
    "phoneNumber": phone,
    "verificationCode": code,
  };

  try {
    http.Response response = await http.post(sourceURL,
        headers: {'content-type': 'application/json'}, body: json.encode(body));
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, dynamic> responseHeaders = response.headers;

    Map<String, String> obj = {
      "type": "${responseBody["type"]}",
      "message": "${responseBody["message"]}",
      "x-auth": "${responseHeaders["x-auth"]}"
    };
    return obj;

  } catch (err) {
    print("no network bahi");
  }

  Map<String, String> obj = {
    "message": "null",
    "type": "null",
    "x-auth": "null"
  };

  return obj;
}


// Logim up verification
Future<Map> verifyLogin(String phone, String code) async {
  String sourceURL = verifyLoginEndPoint;

  Map<String, dynamic> body = {
    "phoneNumber": phone,
    "loginCode": code,
  };

  try {
    http.Response response = await http.post(sourceURL,
        headers: {'content-type': 'application/json'}, body: json.encode(body));
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, dynamic> responseHeaders = response.headers;

    Map<String, String> obj = {
      "type": "${responseBody["type"]}",
      "message": "${responseBody["message"]}",
      "x-auth": "${responseHeaders["x-auth"]}",
      "deviceId":"${responseBody["deviceId"]}"
    };
    return obj;

  } catch (err) {
    print("no network bahi");
  }

  Map<String, String> obj = {
    "message": "null",
    "type": "null",
    "x-auth": "null"
  };

  return obj;
}


Future<Map> login(String phone) async {
  String sourceURL = loginEndPoint;

  Map<String, dynamic> body = {
    "phoneNumber": "$phone"
  };

  try {
    
    http.Response response = await http.post(sourceURL,
        headers: {'content-type': 'application/json'}, body: json.encode(body));
    Map<String, dynamic> responseBody = json.decode(response.body);

    Map<String, String> obj = {
      "type": "${responseBody["type"]}",
      "message": "${responseBody["message"]}",
    };
    return obj;
    
  } catch (err) {
    print("no network bahi");
  }

  Map<String, String> obj = {
    "type": "null",
    "message": "null",
  };

  return obj;
}


//user signs up and get verification code.
Future<Map> resendSignUpCode(String phone) async {
  String sourceURL = resendSignUpCodeEndPoint;

  Map<String, dynamic> body = {
    "phoneNumber": "$phone",
  };

  try {
    http.Response response = await http.post(sourceURL,
        headers: {'content-type': 'application/json'}, body: json.encode(body));
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, String> obj = {
      "type": "${responseBody["type"]}",
      "message": "${responseBody["message"]}",
    };
    return obj;

  } catch (err) {
    print("no network bahi");
  }

  Map<String, String> obj = {
    "message": "null",
    "type": "null",
  };

  return obj;
}


