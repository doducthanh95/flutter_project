import 'package:flutter/material.dart';
import 'package:flutter_app_la_ban/ui/compass_page.dart';
import 'package:flutter_app_la_ban/ui/map_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          MapPage(),
          Container(width: 200, height: 200, child: CompassPage())
        ],
      ),
      // child: Center(
      //   child: CompassPage(),
      // ),
    );
  }
}
