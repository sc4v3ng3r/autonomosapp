import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonos_app/model/User.dart';
import 'FirebaseReferences.dart';

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
          recentCreatedUser.uid,
          recentCreatedUser.displayName, // dados do field name
          recentCreatedUser.email, RATING_INIT_VALUE);

      await USERS_REFERENCE.child(recentCreatedUser.uid)
          .set(user.toJson());

      return user;
    }

    catch (ex) {
      throw ex;
     /* print("Erro ao registar conta do Database");
      recentCreatedUser.delete()
          .then((onValue) => FirebaseAuth.instance.signOut())
          .catchError((error) =>
          print("UserRegisterScreen:: _createAccountDBRegister "
              + error.toString()));*/
    }
  }

}