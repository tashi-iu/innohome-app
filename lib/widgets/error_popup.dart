import 'package:flutter/material.dart';

class ErrorPopup extends StatelessWidget {
  final String text;
  const ErrorPopup({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error_outline, color: Colors.red, size: 48.0,),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(text,
              textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.black.withOpacity(0.7))),
            ),
          ],
        ),
      ),
    );
  }
}
