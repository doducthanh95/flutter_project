import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MapBloc {
  BehaviorSubject<double> _object = BehaviorSubject<double>();
  Stream<double> get stream => _object.stream;

  var _currentPosition = Position(longitude: 0, latitude: 0);

  updateCurrentPosition(Position newPosition) {
    _currentPosition = newPosition;
  }

  LatLng getPosition() {
    return LatLng(_currentPosition.latitude, _currentPosition.longitude);
  }

  setAngle(double value) {
    _object.add(value);
  }

  Future<Position> getLocation() async {
    Position currentLocation;
    try {
      currentLocation =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return currentLocation;
    } on Exception {
      return null;
    }
  }

  dispose() {
    _object.close();
  }
}
