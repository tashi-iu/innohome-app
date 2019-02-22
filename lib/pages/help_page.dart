import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_switch_v2/pages/house_page.dart';

class HelpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HelpPageState();
  }
}

class _HelpPageState extends State<HelpPage> {
  final _controller = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              "assets/help/1.jpg",
              height: 600,
            ),
          ),
          Padding(
            child: Text(
                "This is the main screen. Click on the 'Add Room' button to add your first room",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            padding: EdgeInsets.all(8),
          )
        ],
      ),
      ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              "assets/help/2.jpg",
              height: 600,
            ),
          ),
          Padding(
            child: Text(
                "In this screen, fill in the form and click on the tick mark to save the room (Check your innoHome node device for the Room ID)",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            padding: EdgeInsets.all(8),
          ),
        ],
      ),
      ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              "assets/help/3.jpg",
              height: 600,
            ),
          ),
          Padding(
            child: Text(
                "You will then have added your first room! Tap on the white icon in the top-right corner to change connection mode (Internet or Local WiFi)",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            padding: EdgeInsets.all(8),
          )
        ],
      ),
      ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              "assets/help/4.jpg",
              height: 600,
            ),
          ),
          Padding(
            child: Text(
                "If you have not connected your device to the innoHome wifi network, you will be asked to do so before you proceed to change your connection type. Connect to the innoHome Wifi network from your phone settings and tap 'Try again'",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            padding: EdgeInsets.all(8),
          )
        ],
      ),
      ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              "assets/help/5.jpg",
              height: 600,
            ),
          ),
          Padding(
            child: Text(
                "Tap on the room in the main screen, you will be forwarded to a page similar to this. Tap the light switches to toggle the light switches.",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            padding: EdgeInsets.all(8),
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Icon(
              Icons.check,
              size: 128,
              color: Colors.white,
            ),
          ),
          Padding(
            child: Text("That's it!",
                style: TextStyle(color: Colors.white, fontSize: 48),
                textAlign: TextAlign.center),
            padding: EdgeInsets.all(8),
          ),
          Padding(
            child: Text("Try out the app and save precious time with innoHome",
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center),
            padding: EdgeInsets.fromLTRB(8, 8, 8, 24),
          ),
          Center(
            child: MaterialButton(
              height: 48,
              child: Text(
                "EXPLORE APP",
                style: TextStyle(color: Colors.cyan, fontSize: 24),
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(this.context,
                    MaterialPageRoute(builder: (context) => HousePage()));
              },
            ),
          ),
        ],
      ),
    ];

    return new Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.cyan,
        title: Text(
          "Help",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: new IconTheme(
        data: new IconThemeData(color: _kArrowColor),
        child: new Stack(
          children: <Widget>[
            new PageView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _pages.length,
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                return _pages[index % _pages.length];
              },
            ),
            new Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: new Container(
                color: Colors.grey[800].withOpacity(0.8),
                padding: const EdgeInsets.all(20.0),
                child: new Center(
                  child: new DotsIndicator(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageSelected: (int page) {
                      _controller.animateToPage(
                        page,
                        duration: _kDuration,
                        curve: _kCurve,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
