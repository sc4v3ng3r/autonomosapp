import 'package:autonomosapp/firebase/FirebaseReferences.dart';
import 'package:autonomosapp/model/ProfessionalRating.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class FirebaseProfessionalRatingHelper {
  
  static Future<void> ratingProfessional({@required ProfessionalRating proRating}){
      return FirebaseDatabase.instance.reference()
          .child(FirebaseReferences.REFERENCE_PROFESSIONAL_RATING)
          .child(proRating.proUid)
          .child( proRating.userUid )
          .set( proRating.toJson() );
  }
}