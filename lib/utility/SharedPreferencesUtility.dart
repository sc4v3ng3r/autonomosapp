import 'package:autonomosapp/model/ApplicationState.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtility{

  static Future<void> writePreferencesData(
      { @required String email, @required String password, bool rememberMe = false} ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("WRITING SHARED PREFERENCES EMAIL: $email \nPASSWORD: $password");
    prefs.setBool( ApplicationState.KEY_REMEMBER_ME , rememberMe);
    prefs.setString(ApplicationState.KEY_EMAIL, email);
    prefs.setString(ApplicationState.KEY_PASSWORD, password );
  }

  static void clear(){
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
  }
}