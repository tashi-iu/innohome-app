import 'package:flutter/material.dart';
import 'dart:math' as math;

class LightSwitchIcon extends StatefulWidget {
  final String label;
  final int id; 
  LightSwitchIcon({
    Key key,
    @required this.label,
    @required this.id
  }) : super(key: key);

  @override
  _LightSwitchState createState() => _LightSwitchState();
}

class _LightSwitchState extends State<LightSwitchIcon> {
  bool _toggle = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.cyan.withOpacity(0.1),
      // highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          _toggle = !_toggle;
        });
      },
      child: Container(
        height: 80,
        width: 80,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: _toggle ? Colors.cyan : Colors.grey),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: _toggle ? Colors.cyan : Colors.grey,
                  size: 40.0,
                ),
              ),
            Padding(padding: EdgeInsets.only(bottom: 8.0),),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(height: 0.7,) 
            ),
          ],
        ),
      ),
    );
  }
}
