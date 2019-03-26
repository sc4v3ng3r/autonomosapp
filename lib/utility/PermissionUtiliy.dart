import 'package:autonomosapp/ui/widget/GenericAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

class PermissionUtility {

  static Future<bool> hasLocationPermission() async {
    var handler = PermissionHandler();

    if (Platform.isAndroid){
      PermissionStatus status = await handler
          .checkPermissionStatus( PermissionGroup.locationAlways );
      return (status == PermissionStatus.granted);
    }

    PermissionStatus status = await handler
        .checkPermissionStatus(PermissionGroup.location);

    bool value = false;

    switch(status){
      case PermissionStatus.restricted:
      case PermissionStatus.granted:
      value = true;
      break;

      default:
        break;
    }

    return value;
  }

  static Future<bool> requestLocationPermission() async {
    if (Platform.isAndroid)
      return _requestAndroidLocationPermission();
    else
      return _requestIosLocationPermission();
  }

  static Future<bool> _requestIosLocationPermission() async {
    var handler = PermissionHandler();

    final List<PermissionGroup> permissions = List();
    Map<PermissionGroup, PermissionStatus> results;
    permissions.add(PermissionGroup.location);
    bool flag = false;

    results = await handler.requestPermissions( permissions );
    results.forEach( (key, value) {
      if ( (value == PermissionStatus.granted) || (value == PermissionStatus.restricted) )
        flag = true;

      else flag = false;
    } );

    return flag;
  }

  /// Método ANDROID para requisitar a permissão de Localização
  static Future<bool> _requestAndroidLocationPermission() async {
    var handler = PermissionHandler();

    final List<PermissionGroup> permissions = List();
    Map<PermissionGroup, PermissionStatus> results;
    permissions.add(PermissionGroup.locationAlways);
    bool flag = false;

    if (Platform.isAndroid){
      AndroidDeviceInfo devInfo = await DeviceInfoPlugin().androidInfo;
      if (devInfo.version.sdkInt < 21)
        return true;

      results = await handler.requestPermissions( permissions );
      results.forEach( (key, value) {
        if (value == PermissionStatus.granted)
          flag = true;

        else flag = false;
      } );

    }

    return flag;
  }


  /// Método ANDROID que verifica se há a necessidade de exibir uma razão
  /// para requisitar uma determinada permissão
  static Future<bool> shouldShowReasonableDialog() async{
    var handler = PermissionHandler();
    return await handler
       .shouldShowRequestPermissionRationale(PermissionGroup.locationAlways);
  }

  ///Método ANDROID que abre a tela de confirações do android
  ///para revogar ou conceder permissões.
  static Future<bool> openPermissionSettings() async {
    return await PermissionHandler().openAppSettings();
  }

  static Future<bool> handleLocationPermissionForAndroid(final BuildContext context) async {
    var hasPermission =  await PermissionUtility.hasLocationPermission();

    if (!hasPermission){

      var shouldShowDialog = await PermissionUtility.shouldShowReasonableDialog();
      if (shouldShowDialog){ // devemos exibir uma razao?
        var shouldShowReasonResults = await _showLocationPermissionReasonDialog(context);
        if (shouldShowReasonResults)
          return await PermissionUtility._requestAndroidLocationPermission();
        //usuario nao concorda com as razoes para conceder a permissao
        return false;
      }

      else {
        // nao devemos exibir uma razao...
        // else never ask again was marked
        //necessario dar as permissoes na tela de configurações do OS
        print("Never ask again marked, user must give a permition in application settings");
        var goToSettings = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context){
              return GenericAlertDialog(
                title: "Permissões",
                positiveButtonContent: Text("Ir para configurações"),
                negativeButtonContent: Text("Cancelar"),
                content: Column(
                  children: <Widget>[
                    Text("Você precisa ligar seu GPS ou conceder a permissão de localização "
                        "nas configurações do seu dispositivo.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                      ),
                    ),
                  ],
                ),

              );
            }
        );
        if (goToSettings!= null && goToSettings)
          await PermissionUtility.openPermissionSettings();
        return false;
      }
    } // end of if(!hasPermission)

    // realizar a operacao!!!
    else {
      print("JA tem permissao para realizar operação");
      return true;
    }
  }

  /// Exibe dialog de razão para usuário conceder premissão de localização
  static Future<bool> _showLocationPermissionReasonDialog(final BuildContext context) async {
    return await showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return GenericAlertDialog(
            title: "Permissão de Localização",
            content: Text("Autônomos precisa acessar a localização do dispositivo"),
            positiveButtonContent: Text("Conceder Permissão"),
            negativeButtonContent: Text("Cancelar"),
          );
        }
    );
  }

}

