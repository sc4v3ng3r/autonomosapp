import 'dart:io';

import 'package:autonos_app/utility/Constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

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


  static Future<void> removeUserProfilePicture({@required String userUid }) async {
    try{

      print("REMOVING PICTURE $userUid/${Constants.STORAGE_USER_PICTURE_FILE_NAME}");
      await FirebaseStorage.instance.ref()
          .child("$userUid/${Constants.STORAGE_USER_PICTURE_FILE_NAME}").delete();
    }
    catch (ex){ print(ex); }
  }
}