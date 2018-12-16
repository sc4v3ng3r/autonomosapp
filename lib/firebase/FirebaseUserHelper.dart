import 'package:autonos_app/firebase/FirebaseUfCidadesServicosProfissionaisHelper.dart';
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
    DatabaseReference proRef = FirebaseDatabase.instance.reference()
        .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);

    User user;
    try {
      DataSnapshot snapshot = await USERS_REFERENCE.child(uid).once();
      if (snapshot.value != null){
        print("FirebaseUserHelper user $uid exist in DB!");
        user = User.fromDataSnapshot(snapshot);
      }

       DataSnapshot professionalData = await proRef.child( user.uid ).once();
       if ( (professionalData.value != null) ){
         print("FirebaseUserHelper user $uid has pro data ${professionalData.value.toString()}");
         user.professionalData = ProfessionalData.fromSnapshot( professionalData);
       }

    }

    catch (ex) {
      print("FirebaseUserHelper ${ex.toString()}");
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

  static Future<void> registerUserProfessionalData( final ProfessionalData data ) {
    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);

    FirebaseUfCidadesServicosProfissionaisHelper.writeIntoRelationship(data);
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

  //TODO terminar de implementar essa versão de método!
  static Future<User> getCurrentUser() async {
    User user;
    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(FirebaseReferences.REFERENCE_USERS );

    DatabaseReference proRef = FirebaseDatabase.instance.reference()
      .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);

    try{
      print("getting firebase user");
      FirebaseUser fbUser = await AUTH.currentUser();
      print("FB user got it!");
      if (fbUser != null){
        print("firebase user NOT NULL,getting snapshot");
        DataSnapshot snapshot = await ref.child( fbUser.uid ).once();
        if (snapshot.value != null){
          print("data snapshot ${snapshot.value.toString()}");
        }
      }

    } catch (error){
        print(error);
    }

    print("USER RETURNED $user");
    return user;

  }
}