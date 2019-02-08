import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'dart:io' show Platform;


class LocationUtility {

  static Future<Position> getCurrentPosition({@required LocationAccuracy desiredAccuracy}) async {

    if (Platform.isAndroid) {
      return Geolocator().getCurrentPosition(
          desiredAccuracy: desiredAccuracy
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



