
import 'dart:core';

import 'package:firebase_database/firebase_database.dart';

class ProfessionalRating{
  String userUid;
  String proUid;
  double rating;

  static final String _USER_UID = "userUid";
  static final String _PRO_UID = "proUid";
  static final String _RATING = "rating";

  ProfessionalRating({this.userUid, this.proUid, this.rating});

  /*
  ProfessionalRating.fromJson( Map<String, dynamic> json) :
    userUid = json[_USER_UID],
    proUid = json[_PRO_UID],
    rating = double.parse( json[_RATING]  ?? '0' );


  ProfessionalRating.fromSnapshot( DataSnapshot snapshot) :
    userUid = snapshot.value[_USER_UID],
    proUid = snapshot.value[_PRO_UID],
    rating = snapshot.value[_RATING];
  */
  Map<String, dynamic> toJson() => {
    _USER_UID : this.userUid,
    _PRO_UID : this.proUid,
    _RATING : this.rating
  };



}