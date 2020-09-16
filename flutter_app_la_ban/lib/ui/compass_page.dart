import 'dart:async';
import 'dart:math';
import 'package:flutter_app_la_ban/bloc/compass_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class CompassPage extends StatefulWidget {
  double direction;
  Function(double) callBack;
  CompassPage({this.direction, this.callBack});

  @override
  _CompassPageState createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  final bloc = CompassBloc();

  StreamSubscription _compassSub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // userAccelerometerEvents.listen((event) {
    //   bloc.onSensorAcceleChanged(event);
    // });
    //
    // gyroscopeEvents.listen((event) {
    //   bloc.onSensorMagneChanged(event);
    // });

    _compassSub = FlutterCompass.events.listen((value) {
      print("ddthanh goc alpha $value");
      bloc.setValueDirection(value + 5);
      widget.callBack(value + 5);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
    _compassSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<double>(
            stream: bloc.compassStream,
            builder: (context, snapshot) {
              double value = widget.direction ?? 0;
              if (snapshot.hasData) {
                value = snapshot.data;
                return Transform.rotate(
                  angle: value * (pi / 180) * -1,
                  child: Image.asset("assets/images/compass.png"),
                );
              } else {
                return Container();
              }
            }));
  }
}
