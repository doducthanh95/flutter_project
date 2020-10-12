import 'dart:async';

import 'package:ILaKinh/ui/compass_page.dart';
import 'package:ILaKinh/ui/map_page.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:screenshot/screenshot.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double agle = 0;
  ScreenshotController _screenshotController = ScreenshotController();
  final _object = BehaviorSubject<double>();
  bool _hasPermission = false;

  StreamSubscription _subConnection;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subConnection.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            MapPage(
              object: _object,
              screenshotController: _screenshotController,
            ),
            IgnorePointer(
                child: CompassPage(
              object: _object,
              callBack: (double value) {
                setState(() {
                  agle = value;
                });
              },
            ))
          ],
        ),
      ),
    );
  }
}
