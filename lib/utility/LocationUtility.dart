import 'package:geolocator/geolocator.dart';
import 'package:autonos_app/utility/PermissionUtiliy.dart';
import 'dart:io' show Platform;

class LocationUtility {

  static Future<Position> getCurrentPosition() async {
    if (Platform.isAndroid) {
      var permission = await PermissionUtility.hasLocationPermission();

      if (permission){
        return Geolocator().getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high
        );
      }

      else { // vamos pedir a permissao
        permission = await PermissionUtility.requestAndroidLocationPermission();
        if (permission){
          return Geolocator().getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high
          );
        }
      }

    }

    return null;
  }

  static Future<List<Placemark>> doGeoCoding(Position position) async {
    return Geolocator().placemarkFromCoordinates(
        position.latitude, position.longitude);
  }

}




