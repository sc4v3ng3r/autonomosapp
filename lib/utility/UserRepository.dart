import 'package:autonos_app/model/Location.dart';
import 'package:autonos_app/model/User.dart';

class UserRepository {

  static UserRepository _instance = new UserRepository._internal();
  User currentUser;
  Location currentLocation;

  factory UserRepository(){
    return _instance;
  }

  UserRepository._internal();
}