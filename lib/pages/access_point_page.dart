import 'package:flutter/material.dart';
import '../widgets/login_field.dart';

class AccessPointPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccessPointPageState();
  }
}

class _AccessPointPageState extends State<AccessPointPage> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Configure Access Point",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: LoginInputTextField(
        obscureText: false,
        labelText: "WiFi SSID",
        hintText: "",
      ),
    );
  }
}

