import 'dart:io' show Platform;
import 'package:autonos_app/firebase/FirebaseUserHelper.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum AuthResult {
  INVALID_USER, INVALID_PASSWORD, OK, ERROR
}

class FirebaseAuthHelper {
  static final FirebaseAuth _authInstance=  FirebaseAuth.instance;

  static Future<AuthResult> firebaseAuthWithEmailAndPassword(
  { @required String email, @required String password }) async{

    FirebaseUser firebaseUser;
    try {
      firebaseUser = await _authInstance.signInWithEmailAndPassword(
          email: email, password: password);
    } on PlatformException catch (ex) {
      return _errorHandler(ex);
    }

    return FirebaseUserHelper.readUserAccountData(firebaseUser).then( (user) {
        print("LIDO ${user.name}  ${user.email}");

        // TODO REPO INIT WORKAROUND
        UserRepository rep = new UserRepository();
        rep.currentUser = user;
        rep.fbPassword = password;
        rep.fbLogin = email;
        rep.imageUrl = firebaseUser.photoUrl;
        return AuthResult.OK;

      }).catchError((onError) {
        print( "Cath error 01 ${onError.toString()}");
        _authInstance.signOut();
        return AuthResult.ERROR;
        //_handler.dismiss();
      });
  }

  static Future<bool> firebaseAuthWithFacebook({@required String token}) async{
    print("FirebaseAuth -> Token:" + token);
    User user;
    FirebaseUser firebaseUser = await _authInstance.signInWithFacebook(accessToken: token);
    if (firebaseUser == null)
      return false;

    try {
      user = await FirebaseUserHelper.readUserAccountData(firebaseUser);
      print("USER DATA READED WITH FACEBOOK ${user.email} ${user.name}");
      UserRepository().currentUser = user;
      UserRepository().imageUrl = firebaseUser.photoUrl;
      print("RETURNING TRUE");
      return true;
    }
    catch (ex) {
      user = await FirebaseUserHelper.writeUserAccountData(firebaseUser);

      if (user != null){
        print("USUARIO CRIADO COM SUCESSO!");
        print("CREATED: ${user.name}  ${user.email}");
        UserRepository().currentUser = user;
        return true;
      }

      else {
        _authInstance.signOut();
        return false;
      }

    }
  }

  static AuthResult _errorHandler(PlatformException e){
    var result = AuthResult.ERROR;

    if (Platform.isAndroid) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          result = AuthResult.INVALID_USER;
          break;

        case 'The password is invalid or the user does not have a password.':
          result = AuthResult.INVALID_PASSWORD;
          break;

        default:
          result = AuthResult.ERROR;
          break;
      }
    }

    else if (Platform.isIOS) {
      switch (e.code) {
        case 'Error 17011':
          result = AuthResult.INVALID_USER;
          break;

          case 'Error 17009':
            result = AuthResult.INVALID_PASSWORD;
            break;
      default:
        result = AuthResult.ERROR;
        break;
      }
    }

    return result;
  }

}

