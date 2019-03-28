import 'dart:io' show Platform;
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
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
        //print("LIDO ${user.name}  ${user.email}");

        // TODO REPO INIT WORKAROUND
        UserRepository rep = UserRepository.instance;
        rep.currentUser = user;
        rep.fbPassword = password;
        rep.fbLogin = email;
        return AuthResult.OK;

      }).catchError((onError) {
        print( "Cath error 01 ${onError.toString()}");
        _authInstance.signOut();
        return AuthResult.ERROR;
        //_handler.dismiss();
      });
  }

  ///  final facebookLogin = new FacebookLogin();
  //    final facebookLoginResult = await facebookLogin
  //        .logInWithReadPermissions(['email', 'public_profile']);
  ///    Here we are using FacebookAuthProvider
  ///   AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: token.token);
  static Future<bool> firebaseAuthWithFacebook({@required FacebookAccessToken token}) async {
    //print("FirebaseAuth -> Token:" + token);
    User user;
    AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: token.token);

    FirebaseUser firebaseUser = await _authInstance.signInWithCredential(credential);

    if (firebaseUser == null)
      return false;

    try {
      user = await FirebaseUserHelper.readUserAccountData(firebaseUser);
      user.picturePath = firebaseUser.photoUrl;

      print("USER DATA READED WITH FACEBOOK ${user.email} ${user.name}");
      UserRepository().currentUser = user;
      return true;
    }
    // se eh a primeira vez de login com o facebook, entra nessa parte!
    catch (ex) {

      user = await FirebaseUserHelper.createUserAccountData(firebaseUser);

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


  static Future<FirebaseUser> createUserAccountWithEmailPassword(
      {@required String email, @required password}) async{
    FirebaseUser createdUser;
    try{
      createdUser = await _authInstance.createUserWithEmailAndPassword(
          email: email, password: password);
    }

    catch ( ex ){
      print(ex.toString() );
    }

    return createdUser;
  }

  static Future<FirebaseUser> reauthCurrentUser() async {
    FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();
    UserRepository repository = UserRepository.instance;
    AuthCredential credential;

    var isFacebook = await _userProviderIsFacebook();

    if (isFacebook) {
      print("Facebook reauth");
      FacebookAccessToken accessToken = await FacebookLogin().currentAccessToken;
      credential = FacebookAuthProvider
          .getCredential(accessToken: accessToken.token);

      fbUser = await fbUser.reauthenticateWithCredential( credential )
          .catchError((error){ print("FirebaseAuthHelper::reauthCurrentUser $error"); });
      await fbUser.reload();
      return fbUser;
    }


    //ISSO NAO VAI FUNCIONAR NO IOS pq o repository nao estar guardando o ID & a senha
    // do usuario no IOS!
    credential = EmailAuthProvider.getCredential(
        email: repository.fbLogin,
        password: repository.fbPassword);

    fbUser = await fbUser.reauthenticateWithCredential( credential )
        .catchError((error){ print("FirebaseAuthHelper::reauthCurrentUser $error"); });
    await fbUser.reload();
    return fbUser;
  }

  static Future<bool> _userProviderIsFacebook() async {
    FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();
    var providerIndex = 0; // ios provider index
    if (Platform.isAndroid)
      providerIndex = 1;

    return (fbUser.providerData[providerIndex].providerId.compareTo( Constants.PROVIDER_ID_FACEBOOK ) == 0);
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

