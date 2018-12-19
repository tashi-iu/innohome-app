import 'package:flutter/material.dart';
import './pages/landing_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inno Bhutan',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LandingPage(title: 'innoHome',),
    );
  }
}