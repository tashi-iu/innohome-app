import 'package:flutter/material.dart';

class LightSwitch extends StatefulWidget {
  @override
  _LightSwitchState createState() => _LightSwitchState();
}

class _LightSwitchState extends State<LightSwitch> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index){
        return ListTile();
      },
    );
  }
}