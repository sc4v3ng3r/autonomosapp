import 'package:autonos_app/model/ProfessionalData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/firebase/FirebaseReferences.dart';

class FirebaseUserHelper {
  static final RATING_INIT_VALUE = 5.0;
  static final FirebaseAuth AUTH = FirebaseAuth.instance;
  //final FirebaseDatabase m_database = FirebaseDatabase.instance;

  static final DatabaseReference USERS_REFERENCE = FirebaseDatabase.instance
      .reference()
      .child( FirebaseReferences.REFERENCE_USERS );

  static Future<User> readUserAccountData(String uid) async {
    User user;
    try {
      DataSnapshot snapshot = await USERS_REFERENCE.child(uid).once();
       user = User.fromDataSnapshot(snapshot);
    }

    catch (ex) {
      throw ex;
    }

    return user;
  }

  static Future<User> writeUserAccountData(FirebaseUser recentCreatedUser)  async {
    try {
      print("Registrando conta no DB!");
      User user = new User(
        uid: recentCreatedUser.uid,
        email: recentCreatedUser.email,
        name: recentCreatedUser.displayName,
        rating: RATING_INIT_VALUE,
      );

      await USERS_REFERENCE.child(recentCreatedUser.uid)
          .set(user.toJson());

      return user;
    }

    catch (ex) {
      throw ex;
    }
  }

  static Future<void> registerUserProfessionalData( ProfessionalData data ) {
    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);
    return ref.child( data.uid ).set( data.toJson() );
  }

  // TODO MELHORAR ESSE METODO
  static Future<User> currentLoggedUser() async {
    try {
      FirebaseUser fbUser = await AUTH.currentUser();
      return await readUserAccountData( fbUser.uid );
      //return user;
    }
    catch (ex){
      print("FirebaseUserHelper::" + ex.toString());
      throw ex;
    }

  }

}