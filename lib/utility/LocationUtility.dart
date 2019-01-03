import 'package:geolocator/geolocator.dart';
import 'package:autonos_app/utility/PermissionUtiliy.dart';
import 'dart:io' show Platform;

class LocationUtility {

  static Future<Position> getCurrentPosition() async {
    if (Platform.isAndroid) {
      return Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
    }

    //TODO iOS
    return null;
  }

  static Future<List<Placemark>> doGeoCoding(Position position) async {
    return Geolocator().placemarkFromCoordinates(
        position.latitude, position.longitude);
  }

}




