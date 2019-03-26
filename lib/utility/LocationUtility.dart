import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

class LocationUtility {

  static Future<Position> getCurrentPosition({@required LocationAccuracy desiredAccuracy}) async {
    return Geolocator().getCurrentPosition(
          desiredAccuracy: desiredAccuracy
      );
  }

  static Future<List<Placemark>> doGeoCoding(Position position) async {
    return Geolocator().placemarkFromCoordinates(
        position.latitude, position.longitude);
  }
}