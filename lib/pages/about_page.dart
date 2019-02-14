import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.cyan),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "About innoHome",
          style: TextStyle(color: Colors.cyan, fontSize: 24),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 128,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 18),
                  child: Image.asset(
                  "assets/icon/icon.png",
                  width: 128,
                ),
                )
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "A quick brown fox jumped over the lazy dog. A quick brown fox jumped over the lazy dog. A quick brown fox jumped over the lazy dog. A quick brown fox jumped over the lazy dog. A quick brown fox jumped over the lazy dog. ",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.95), fontSize: 18),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                "Contact us",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.95), fontSize: 18),
              ),
              FlatButton(
                child: Text(
                  "innohome@gmail.com",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {},
              ),
              FlatButton(
                child: Text(
                  "+97517777777",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
