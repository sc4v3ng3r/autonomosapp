import 'dart:io';

import 'package:autonomosapp/utility/Constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageHelper {

  ///Esse método salva a picture no firebase Storage e retorna a Url de download.
  static Future<String> saveUserProfilePicture({
    @required File picture, @required String userUid}) async {
    String pictureDownloadUrl;

    final StorageReference ref = FirebaseStorage.instance.ref()
        .child("$userUid/${Constants.STORAGE_USER_PICTURE_FILE_NAME}");

    try {
      final StorageUploadTask uploadTask = ref.putFile(picture);
      final StorageTaskSnapshot snapshotTask = (await uploadTask?.onComplete);
      pictureDownloadUrl = await snapshotTask.ref.getDownloadURL();
    }

    catch (ex) {
      print( "FirebaseStorageHelper::saveUserProfilePicture() ${ex.toString()}" );
    }
    return pictureDownloadUrl;
  }

  static void removeUserFiles({@required String userUid }) {

      print("REMOVING PICTURE $userUid/${Constants.STORAGE_USER_PICTURE_FILE_NAME}");
      StorageReference ref = FirebaseStorage.instance.ref();

      //ref.child("$userUid/${Constants.STORAGE_USER_PICTURE_FILE_NAME}").delete();

      ref.child("${Constants.STORAGE_DOCUMENTS}/$userUid/"
          "${Constants.STORAGE_FRENTE_RG}").delete().catchError((error){print("Arquivo nao existe!");});

      ref.child("${Constants.STORAGE_DOCUMENTS}/$userUid/"
          "${Constants.STORAGE_VERSO_RG}").delete().catchError((error){print("Arquivo nao existe!");});

      ref.child("${Constants.STORAGE_DOCUMENTS}/$userUid/"
          "${Constants.STORAGE_PESSOA_RG}").delete().catchError((error){print("Arquivo nao existe!");});

      FirebaseStorage.instance.ref()
          .child("$userUid/${Constants.STORAGE_USER_PICTURE_FILE_NAME}").delete()
          .catchError((error){print("Arquivo nao existe!");});
  }

  static Future<String> saveDocumentPictureIntoStorage({@required final String name,
    @required final File picture, @required final String userUid}) async {
    String pictureDownloadUrl;

    final StorageReference ref = FirebaseStorage.instance.ref()
        .child("${Constants.STORAGE_DOCUMENTS}/$userUid/$name");

    try {
      final StorageUploadTask uploadTask = ref.putFile(picture);
      final StorageTaskSnapshot snapshotTask = (await uploadTask?.onComplete);
      pictureDownloadUrl = await snapshotTask.ref.getDownloadURL();
    }

    catch (ex) {
      print( "FirebaseStorageHelper::saveUserProfilePicture() ${ex.toString()}" );
    }

    return pictureDownloadUrl;

  }

  static Future<File> getUserTermFile() async{
    StorageReference ref = FirebaseStorage.instance.ref();
    String fileUrl = await ref.child("termoDeUso/Termo_e_politica_de_privacidade_IDO.pdf").getDownloadURL();
    return _createFileOfPdfUrl(fileUrl);
  }


  static Future<File> _createFileOfPdfUrl(final String url) async {
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }


}