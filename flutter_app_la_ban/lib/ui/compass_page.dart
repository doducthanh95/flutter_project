import 'dart:math';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class CompassPage extends StatefulWidget {
  double direction;

  CompassPage({this.direction});

  @override
  _CompassPageState createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  BehaviorSubject _compassObser = BehaviorSubject<double>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FlutterCompass.events.listen((value) {
      setState(() {
        widget.direction = value;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
      angle: (widget.direction ?? 0) * (pi / 180) * -1,
      child: Image.asset("assets/images/compass.png"),
    ));
  }
}
