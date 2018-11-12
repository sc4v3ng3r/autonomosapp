//import 'package:meta/meta.dart';

import 'package:firebase_database/firebase_database.dart';

class User {
  String name;
  String email;
  //String _picturePath;
  String uid;
  double rating;

  static final String EMAIL = "email";
  static final String NAME = "name";
  static final String UID = "uid";
  static final String RATING = "rating";
  static final String PHOTO_PATH = "photo_path";

  User(String uid, String name, String email, double rating) :
    uid = uid,
    name = name,
    email = email,
    rating = rating;

  User.fromJson(Map<String, dynamic> json) :
      name = json[NAME],
      email = json[EMAIL],
      uid = json[UID],
      rating = json[RATING];

  Map<String, dynamic> toJson() => {
    'name' : name,
    'email' : email,
    'rating' : rating,
    'uid' : uid,
  };

  User.fromDataSnapshot(DataSnapshot snapshot ) :
    name = snapshot.value[NAME],
    email = snapshot.value[EMAIL],
    rating = double.parse( (snapshot.value[RATING]).toString() ),
    uid =   snapshot.value[UID];


}