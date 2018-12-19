import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map> postData(String room, String switchName, String toggle) async {
  String sourceURL = "http://192.168.128.88:3000/smart-switch/send-data-demo";

  http.Response response = await http.post(sourceURL, body: json.encode({"room":"$room", "switchName":"$switchName", "toggle":"$toggle"}), headers: {"Content-type": "application/json", "Accept": "application/json"});
  return json.decode(response.body);
}
