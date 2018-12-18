import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Location {
  double latitude;
  double longitude;

  static final _LATITUDE = "latitude";
  static final _LONGITUDE = "longitde";

  Location({@required double latitude, @required double longitude})
    : this.latitude = latitude,
      this.longitude = longitude;


  Map<String, dynamic> toJson() => {
    _LATITUDE : latitude,
    _LONGITUDE : longitude,
  };


  Location.fromJson(Map<String, dynamic> json) :
      latitude = json[_LATITUDE],
      longitude = json[_LONGITUDE];


  Location.fromSnapshot(DataSnapshot snapshot) :
      latitude = snapshot.value[_LATITUDE],
      longitude = snapshot.value[_LONGITUDE];

}