
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class UserView {
  String id;
  String userVisualizedId;
  String userVisitorId;

  static const String viewId = "id";
  static const String visitorId = "visitorId";
  static const String visualizedId = "visualizedId";

  UserView({@required this.userVisitorId, @required this.userVisualizedId});

  UserView.fromJson(Map<String, dynamic> json) :
    this.id = json[viewId],
    this.userVisualizedId = json[visualizedId],
    this.userVisitorId = json[visitorId];

  UserView.fromSnapshot( DataSnapshot snapshot) :
    this.id = snapshot.value[viewId],
    this.userVisualizedId = snapshot.value[visualizedId],
    this.userVisitorId = snapshot.value[visitorId];

  Map<String, dynamic> toJson() => {
    viewId : id,
    visitorId : userVisitorId,
    visualizedId : userVisualizedId,
  };

}