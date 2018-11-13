//import 'package:meta/meta.dart';

import 'package:firebase_database/firebase_database.dart';

class User {
  String name;
  String email;
  String picturePath;
  String uid;
  double rating;

  static final String EMAIL = "email";
  static final String NAME = "name";
  static final String UID = "uid";
  static final String RATING = "rating";
  static final String PICTURE_URL = "photo_url";

  User(String uid, String name, String email, double rating) :
    uid = uid,
    name = name,
    email = email,
    rating = rating;

  User.fromJson(Map<String, dynamic> json) :
      name = json[NAME],
      email = json[EMAIL],
      uid = json[UID],
      rating = json[RATING],
      picturePath = json[PICTURE_URL];

  Map<String, dynamic> toJson() => {
     NAME : name,
    EMAIL : email,
    RATING : rating,
    UID : uid,
    PICTURE_URL : picturePath,
  };

  User.fromDataSnapshot(DataSnapshot snapshot ) :
    name = snapshot.value[NAME],
    email = snapshot.value[EMAIL],
    rating = double.parse( (snapshot.value[RATING]).toString() ),
    uid =   snapshot.value[UID],
    picturePath = snapshot.value[PICTURE_URL];

}