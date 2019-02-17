import 'package:wifi/wifi.dart';

Future<String> checkSSID() async {
  String ssid = await Wifi.ssid;
  return ssid;
}

void listWifi() async {
  Wifi.list('').then((list) {
    
  });
}
