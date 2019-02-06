import 'dart:io';

import 'package:autonomosapp/model/ApplicationState.dart';
import 'package:autonomosapp/model/Location.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserRepository {

  static UserRepository _instance = new UserRepository._internal();
  static UserRepository get instance => _instance;
  User currentUser;
  Location currentLocation;

  SharedPreferences preferences;
  String fbPassword="";/// password se a conta for de algum provider do firebase
  String fbLogin=""; /// login se a conta for de algum provier do firebase

  factory UserRepository(){
    return _instance;
  }

  UserRepository._internal( ){
    SharedPreferences.getInstance().then((value) {
      preferences = value;
      fbPassword = preferences.getString(ApplicationState.KEY_PASSWORD );
      fbLogin = preferences.getString(ApplicationState.KEY_EMAIL);
    });
  }

  void clearPreferences(){
    preferences.clear();
  }
}