import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_la_ban/bloc/compass_bloc.dart';
import 'package:flutter_app_la_ban/bloc/map_bloc.dart';
import 'package:flutter_app_la_ban/ui/search_address_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:route_transitions/route_transitions.dart';

class MapPage extends StatefulWidget {
  double agle = 0;

  MapPage({this.agle});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  final bloc = MapBloc();
  final compassBloc = CompassBloc();

  Position _position;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    tilt: 10,
    bearing: 90,
    zoom: 18,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    // TODO: implement initState
    bloc.getLocation().then((position) {
      _position = position;
      _updatePosition(position, widget.agle);
    });

    // compassBloc.changeMapViewStream.listen((value) {
    //   print("ddthanh listen compass change");
    //   _updatePosition(_position, value);
    // });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        buildingsEnabled: true,
        myLocationEnabled: true,
        mapToolbarEnabled: true,
        compassEnabled: false,
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          showCupertinoModalBottomSheet(
              context: context,
              builder: (context, scroll) => SearchAddressPage());
        },
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  _updatePosition(Position data, double agle) {
    _controller.future.then((value) {
      var position = CameraPosition(
          target: LatLng(data.latitude, data.longitude),
          bearing: agle ?? 0,
          zoom: 18);
      value.moveCamera(CameraUpdate.newCameraPosition(position));
      print("ddthanh: $data");
      print(value.getVisibleRegion().then((value1) => print(value1)));
    });
  }
}
