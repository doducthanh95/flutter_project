import 'package:geolocator/geolocator.dart';

class MapBloc {
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

  dispose() {}
}
