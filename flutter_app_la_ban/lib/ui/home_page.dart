import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_la_ban/ui/compass_page.dart';
import 'package:flutter_app_la_ban/ui/map_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double agle = 0;

  StreamSubscription _subConnection;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subConnection = Connectivity().onConnectivityChanged.listen((event) {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subConnection.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          MapPage(
            agle: agle,
          ),
          IgnorePointer(child: CompassPage(
            callBack: (double value) {
              setState(() {
                agle = value;
              });
            },
          ))
        ],
      ),
      // child: Center(
      //   child: CompassPage(),
      // ),
    );
  }
}
