import 'package:flutter/material.dart';
import '../pages/room_page.dart';

class RoomCard extends StatefulWidget {
  RoomCard({Key key, this.roomName}) : super(key: key);

  final String roomName;

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        color: Colors.lightBlue,
        elevation: 2.0,
        child: InkWell(
          child: Center(
            child: Text(
              widget.roomName,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 18.0),
            ),
          ),
          onTap: () {
            print("hello");          },
        ),
      ),
    );
  }
}
