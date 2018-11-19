import 'package:meta/meta.dart';

class Service {
  int _id;
  String _name;

  static final String ID = "id";
  static final String NAME = "name";

  String get name => _name;
  int get id => _id;

  Service(this._id, this._name);

  Service.fromJson(Map<String, dynamic> json) :
      _id = json[ID],
      _name = json[NAME];


  Service.fromString(int index, String name) :
      _id = index,
      _name = name;

  Map<String, dynamic> toJson () => {
    ID : _id,
    NAME : _name,
  };


}

/*
* Map<String, dynamic> toJson() => {
     NAME : name,
    EMAIL : email,
    RATING : rating,
    UID : uid,
    PICTURE_URL : picturePath,
  };*/