import 'package:autonomosapp/model/UserView.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'FirebaseReferences.dart';

class FirebaseUserViewsHelper {
 /* static final DatabaseReference _historyRef = FirebaseDatabase.instance
      .reference().child( FirebaseReferences.REFERENCE_HISTORICO);
  */
  static final DatabaseReference _viewsRef = FirebaseDatabase.instance
      .reference().child( FirebaseReferences.REFERENCE_VISUALZACOES);


  static Future<void> pushUserVisualization( {@required UserView viewData} ) async {
    var pushReference = _viewsRef.child( viewData.userVisualizedId ).push();
    pushReference.set( viewData.toViewJson() );
  }


  static Future<DataSnapshot> getUserVisualizations({@required String uid}) async {
    return _viewsRef.child(uid).limitToFirst(50).once();
  }

  static Future<void> removeAllUserViews( {@required String userId } ) async {
    return _viewsRef.child(userId).remove();
  }

  static Future<void> removeUserViews( {@required String uid,
    @required List<String> viewsIds} ) async {
    for(String viewId in viewsIds)
      _viewsRef.child(uid).child(viewId).remove();
  }

/*
  static Future<void> _removeAllUserHistory( {@required userId}) async {
    return _historyRef.child(userId).remove();
  }*/

/*
  static Future<void> _pushUserHistory( {@required UserView historyData} ) async {
    var pushReference = _historyRef.child( historyData.userVisitorId ).push();
    pushReference.set( historyData.toHistoryJson() );
  }*/

/*
  static Future<DataSnapshot> getUserHistory({@required String uid})  async {
    return _historyRef.child(uid).limitToFirst(50).once();
  }*/



}