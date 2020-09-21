import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_la_ban/bloc/compass_bloc.dart';
import 'package:flutter_app_la_ban/bloc/map_bloc.dart';
import 'package:flutter_app_la_ban/const/const_value.dart';
import 'package:flutter_app_la_ban/ui/search_address_page.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/staticmap.dart';
import 'package:google_maps_webservice/timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiAndroidKey);

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
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
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
    _getCurrentPosition();
    _fetchPermissionStatus();

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
      key: homeScaffoldKey,
      body: GoogleMap(
        buildingsEnabled: true,
        myLocationEnabled: true,
        mapToolbarEnabled: true,
        compassEnabled: true,
        mapType: MapType.hybrid,
        indoorViewEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(right: (MediaQuery.of(context).size.width - 100)),
        child: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () async {
            Prediction p = await PlacesAutocomplete.show(
              context: context,
              apiKey: kGoogleApiAndroidKey,
              mode: Mode.overlay, // Mode.fullscreen
              language: "vi",
              components: [new Component(Component.country, "vn")],
            );
            displayPrediction(p, homeScaffoldKey.currentState);
          },
        ),
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

  void _fetchPermissionStatus() async {
    if (await _checkIsFirstRunApp()) {
      return;
    }
    var permissionLocation = await Permission.locationWhenInUse.status;
    if (permissionLocation != PermissionStatus.granted) {
      //AppSettings.openLocationSettings();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text(
                    "Bạn cần cấp quyền vị trí cho ứng dụng để hiển thị chính xác bản đồ"),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Huỷ"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      AppSettings.openLocationSettings().then((value) {
                        _getCurrentPosition();
                      });
                    },
                    child: Text("Đồng ý"),
                  )
                ],
              ));
    }
  }

  Future<bool> _checkIsFirstRunApp() async {
    SharedPreferences _preference = await SharedPreferences.getInstance();
    if (_preference.getBool("IsFirstRun") ?? true) {
      _preference.setBool("IsFirstRun", false);
      return true;
    }
    return false;
  }

  _getCurrentPosition() async {
    bloc.getLocation().then((position) {
      _position = position;
      _updatePosition(position, 0);
    });
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }
}
