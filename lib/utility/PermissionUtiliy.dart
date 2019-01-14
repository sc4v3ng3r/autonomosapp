import 'package:permission_handler/permission_handler.dart';
import 'package:device_info/device_info.dart';

class PermissionUtility {

  static final PermissionHandler _handler = PermissionHandler();

  /// Método ANDROID para verificar se há permissão de localização
  static Future<bool> hasLocationPermission() async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus( PermissionGroup.locationAlways );
    return (status == PermissionStatus.granted);
  }

  /// Método ANDROID para requisitar a permissão de Localização
  static Future<bool> requestAndroidLocationPermission() async {

    AndroidDeviceInfo devInfo = await DeviceInfoPlugin().androidInfo;
    final List<PermissionGroup> permissions = List();
    Map<PermissionGroup, PermissionStatus> results;
    permissions.add(PermissionGroup.locationAlways);
    bool flag = false;

    if (devInfo.version.sdkInt < 21)
      return true;

      results = await _handler.requestPermissions( permissions );
      results.forEach( (key, value) {
        if (value == PermissionStatus.granted)
          flag = true;

        else flag = false;
      } );
    
    return flag;
  }

  /// Método ANDROID que verifica se há a necessidade de exibir uma razão
  /// para requisitar uma determinada permissão
  static Future<bool> shouldShowReasonableDialog() async{
   return await _handler
       .shouldShowRequestPermissionRationale(PermissionGroup.locationAlways);
  }

  ///Método ANDROID que abre a tela de confirações do android
  ///para revogar ou conceder permissões.
  static Future<bool> openPermissionSettings() async {
    return await _handler.openAppSettings();
  }




}

