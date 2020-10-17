import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ILaKinh/bloc/compass_bloc.dart';
import 'package:ILaKinh/bloc/map_bloc.dart';
import 'package:ILaKinh/const/const_value.dart';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:google_maps_webservice/staticmap.dart';
import 'package:google_maps_webservice/timezone.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiAndroidKey);

class MapPage extends StatefulWidget {
  MapBloc bloc;
  MapPage({this.bloc});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  Position _position =
      Position(latitude: 37.42796133580664, longitude: -122.085749655962);
  double angle = 0;
  double _zoom = 20;

  CameraPosition _kGooglePlex;

  StreamSubscription subscription;
  StreamSubscription subscriptionCompass;

  @override
  void initState() {
    _kGooglePlex = CameraPosition(
      target: LatLng(_position.latitude, _position.longitude),
      tilt: 10,
      bearing: angle,
      zoom: _zoom,
    );
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    _getCurrentPosition();
    _fetchPermissionStatus();

    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (!(result == ConnectivityResult.none)) {
        homeScaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Không có kết nối internet"),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ));
      }
    });

    subscriptionCompass = widget.bloc.streamDeepLink.listen((event) {
      _updatePosition(
          Position(latitude: event.latitude, longitude: event.longitude), 20);
    });
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
    subscriptionCompass.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: homeScaffoldKey,
      body: GoogleMap(
        buildingsEnabled: true,
        myLocationEnabled: true,
        mapToolbarEnabled: true,
        rotateGesturesEnabled: true,
        compassEnabled: true,
        mapType: MapType.hybrid,
        indoorViewEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onCameraMove: (p) {
          widget.bloc.setAngleForCompass(p.bearing);
          widget.bloc.updateCurrentPosition(Position(
              latitude: p.target.latitude, longitude: p.target.longitude));
          _zoom = p.zoom;
          _position = Position(
              latitude: p.target.latitude, longitude: p.target.longitude);
        },
      ),
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(right: (MediaQuery.of(context).size.width - 100)),
        child: FloatingActionButton(
            child: Icon(Icons.search), onPressed: _searchLocation),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  _updatePosition(Position data, double agle) {
    _controller.future.then((value) {
      var position = CameraPosition(
          target: LatLng(data.latitude, data.longitude),
          bearing: agle ?? 0,
          zoom: _zoom);
      value.moveCamera(CameraUpdate.newCameraPosition(position));
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
    widget.bloc.getLocation().then((position) {
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

      _position = Position(longitude: lng, latitude: lat);

      _updatePosition(Position(longitude: lng, latitude: lat), 0);

      // scaffold.showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      // );
    }
  }

  _searchLocation() async {
    Navigator.pop(context);
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiAndroidKey,
      mode: Mode.overlay, // Mode.fullscreen
      language: "vi",
      components: [new Component(Component.country, "vn")],
    );
    displayPrediction(p, homeScaffoldKey.currentState);
  }
}
