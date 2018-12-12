import 'package:permission_handler/permission_handler.dart';
import 'package:device_info/device_info.dart';
class PermissionUtility {

  static Future<bool> hasLocationPermission() async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus( PermissionGroup.locationAlways );
    return (status == PermissionStatus.granted);

  }

  static Future<bool> requestAndroidLocationPermission() async {

    AndroidDeviceInfo devInfo = await DeviceInfoPlugin().androidInfo;
    PermissionHandler handler = PermissionHandler();
    final List<PermissionGroup> permissions = List();
    Map<PermissionGroup, PermissionStatus> results;
    permissions.add(PermissionGroup.locationAlways);
    bool flag = false;

    if (devInfo.version.sdkInt < 21){
      return true;
    }

    bool rationale = await handler.shouldShowRequestPermissionRationale(PermissionGroup.locationAlways);
    if (rationale){
      print("show reason to ask permission.. for while requesting again!");
      handler.requestPermissions(permissions);
    }
    else {
      results = await handler.requestPermissions( permissions );
      results.forEach( (key, value) {
        if (value == PermissionStatus.granted)
          flag = true;

        else flag = false;
      } );
    }
    
    
    return flag;
  }
}