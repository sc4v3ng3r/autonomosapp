import 'package:autonos_app/model/Location.dart';
import 'package:autonos_app/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {

  static UserRepository _instance = new UserRepository._internal();
  User currentUser;
  Location currentLocation;
  SharedPreferences preferences;

  factory UserRepository(){
    return _instance;
  }

  UserRepository._internal( ){
    SharedPreferences.getInstance().then((value) { preferences = value; });
  }
}