//import 'package:meta/meta.dart';

class User {
  String _name;
  String _email;
  //String _picturePath;
  String _uid;
  double _rating;

  String get name => _name;
  String get email => _email;
  String get uid => _uid;

  double get rating => _rating;

  set name(String name) => _name = name;
  set email(String email) => _email = email;
  set rating(double rating) => _rating = rating;

  User(String uid, String name, String email, double rating) :
    _uid = uid,
    _name = name,
    _email = email,
    _rating = rating
  {}


}