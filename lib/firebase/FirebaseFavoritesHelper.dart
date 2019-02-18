import 'package:autonomosapp/firebase/FirebaseReferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class FirebaseFavouritesHelper {

  static Future<void> favoriteProfessional({@required String uid,
    @required String professionalUid}) async {
    return FirebaseDatabase.instance
        .reference().child(FirebaseReferences.REFERENCE_FAVORITOS)
        .child(uid).child(professionalUid).set(professionalUid );

  }

  static Future<void> unFavouriteProfessional({@required String uid,
    @required String professionalUid}) async {
    return FirebaseDatabase.instance
        .reference().child(FirebaseReferences.REFERENCE_FAVORITOS)
        .child(uid).child(professionalUid).remove();

  }

  static Future<DataSnapshot> getUserFavourites({@required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference().child(FirebaseReferences.REFERENCE_FAVORITOS);

    return ref.child(uid).once();
  }

  static Future<void> removeFavoriteUser({@required String uid,
    @required String favouriteUid}) async {

    return FirebaseDatabase.instance
       .reference()
       .child(FirebaseReferences.REFERENCE_FAVORITOS)
       .child(uid)
       .child(favouriteUid).remove();
  }
}