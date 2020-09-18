import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_la_ban/bloc/compass_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:charcode/ascii.dart';
import 'package:charcode/html_entity.dart';

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

  String alpha = "0";

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
      double coordinate =
          (value + 90) < 360 ? (value + 90) : (value + 90 - 360);
      setState(() {
        alpha = double.parse((coordinate).toStringAsFixed(2)).toString();
      });
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
        child: Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.1),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                child: StreamBuilder<double>(
                    stream: bloc.compassStream,
                    builder: (context, snapshot) {
                      double value = widget.direction ?? 0;
                      if (snapshot.hasData) {
                        value = snapshot.data;
                        return Transform.rotate(
                          angle: value * (pi / 180) * -1,
                          child: Container(
                              child: Image.asset(
                            "assets/images/compass.png",
                            width: MediaQuery.of(context).size.width * 4 / 5,
                            height: MediaQuery.of(context).size.width * 4 / 5,
                          )),
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
              Container(
                child: Image.asset(
                  "assets/images/coordinate.png",
                  width: MediaQuery.of(context).size.width * 4 / 5,
                  height: MediaQuery.of(context).size.width * 4 / 5,
                ),
              ),
            ],
          ),
          Positioned(
            top: 150,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  color: Colors.black.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(12),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: alpha + "\u00B0",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 26)),
                    TextSpan(
                        text: " Tây",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.normal,
                            fontSize: 18))
                  ]),
                )),
          )
        ],
      ),
    ));
  }
}
