import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class UserView {
  String id;
  String userVisualizedId;
  String userVisitorId;
  String date;

  static const String _viewId = "id";
  static const String _visitorId = "visitorId";
  static const String _visualizedId = "visualizedId";
  static const String _visitDate = "date";

  UserView({@required this.userVisitorId, @required this.userVisualizedId, @required this.date});

  UserView.fromJson( final Map<String, dynamic> json) :
    //this.id = json[_viewId],
    this.date = json[_visitDate],
    this.userVisualizedId = json[_visualizedId],
    this.userVisitorId = json[_visitorId];

  UserView.fromSnapshot( final DataSnapshot snapshot) :
    this.id = snapshot.value[_viewId],
    this.date = snapshot.value[_visitDate],
    this.userVisualizedId = snapshot.value[_visualizedId],
    this.userVisitorId = snapshot.value[_visitorId];

  Map<String, dynamic> toViewJson() => {
    //_viewId : id,
    _visitDate : date,
    _visitorId : userVisitorId,
    //_visualizedId : userVisualizedId,
  };

  @override
  String toString() {
    return "ID: $id \n$_visitorId : $userVisitorId\n";
  }
  /*Map<String, dynamic> toHistoryJson() => {
    _viewId : id,
    _date : date,
    //_visitorId : userVisitorId,
    _visualizedId : userVisualizedId,
  };*/
}