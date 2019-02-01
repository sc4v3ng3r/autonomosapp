import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autonomosapp/model/User.dart';

class ApplicationState {

  static const String  KEY_TOKEN = "TOKEN";
  static const String KEY_REMEMBER_ME = "REMEMBER_ME";
  static const String KEY_EMAIL = "EMAIL";
  static const String KEY_PASSWORD = "PASSWORD";
  static const String KEY_USER = "USER";

  User loggedUser;
  bool rememberMeCheckMark;
  String facebookToken;
  String email;
  String password;

  ApplicationState(this.rememberMeCheckMark);

  static Future<SharedPreferences> readApplicationState() async {
    try{
      UserRepository().currentUser = await FirebaseUserHelper.currentLoggedUser();
      print("getting SharedPreferences");
    } catch (ex){}

    finally{
      return await SharedPreferences.getInstance();
    }


  }
}

