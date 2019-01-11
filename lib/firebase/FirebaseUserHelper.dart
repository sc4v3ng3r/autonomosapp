import 'package:autonos_app/firebase/FirebaseUfCidadesServicosProfissionaisHelper.dart';
import 'package:autonos_app/model/ApplicationState.dart';
import 'package:autonos_app/model/ProfessionalData.dart';
import 'package:autonos_app/utility/SharedPreferencesUtility.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/firebase/FirebaseReferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FirebaseUserHelper {
  static final RATING_INIT_VALUE = 5.0;
  static final FirebaseAuth AUTH = FirebaseAuth.instance;
  static const String _PROVIDER_ID_FACEBOOK = "facebook.com";
  static const String _PROVIDER_ID_PASSWORD = "password";
  //final FirebaseDatabase m_database = FirebaseDatabase.instance;

  static final DatabaseReference USERS_REFERENCE = FirebaseDatabase.instance
      .reference()
      .child(FirebaseReferences.REFERENCE_USERS);

  // TODO melhorar a execução deste método!ls

  static Future<User> readUserAccountData(FirebaseUser fbUser) async {
    DatabaseReference proRef = FirebaseDatabase.instance
        .reference()
        .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);

    User user;
    String uid = fbUser.uid;
    try {
      DataSnapshot snapshot = await USERS_REFERENCE.child(uid).once();
      if (snapshot.value != null) {
        print("FirebaseUserHelper user $uid exist in DB!");
        user = User.fromDataSnapshot(snapshot);
        UserRepository().imageUrl = fbUser.photoUrl;
      }

      DataSnapshot professionalData = await proRef.child(user.uid).once();
      if ((professionalData.value != null)) {
        print(
            "FirebaseUserHelper user $uid has pro data ${professionalData.value.toString()}");
        user.professionalData = ProfessionalData.fromSnapshot(professionalData);
      }
    } catch (ex) {
      print("FirebaseUserHelper ${ex.toString()}");
      throw ex;
    }

    return user;
  }

  static Future<User> writeUserAccountData(
      FirebaseUser recentCreatedUser) async {
    try {
      print("Registrando conta no DB!");
      User user = new User(
        uid: recentCreatedUser.uid,
        email: recentCreatedUser.email,
        name: recentCreatedUser.displayName,
        rating: RATING_INIT_VALUE,
      );

      await USERS_REFERENCE.child(recentCreatedUser.uid).set(user.toJson());

      return user;
    } catch (ex) {
      throw ex;
    }
  }

  static Future<void> registerUserProfessionalData(
      final ProfessionalData data) {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);

    FirebaseUfCidadesServicosProfissionaisHelper.writeIntoRelationship(data);
    return ref.child(data.uid).set(data.toJson());
  }

  // TODO MELHORAR ESSE METODO
  static Future<User> currentLoggedUser() async {
    try {
      FirebaseUser fbUser = await AUTH.currentUser();
      if (fbUser == null)
        return null;
      return await readUserAccountData(fbUser);
    }
    catch (ex) {
      print("FirebaseUserHelper::" + ex.toString());
      throw ex;
    }
  }

  static Future<Map<String,dynamic>> getProfessionalsData( List<String> ids) async {

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);

    Map<String, dynamic> map = Map();
    for(String id in ids){
     var snapshot = await ref.child(id).once();
      print(snapshot.value.toString());
      map.putIfAbsent( id, () => snapshot.value );
     //list.add(  );
    }
    return map;
  }

  /// Remove os dados do firebase real time database
  /// relacionados a um usuario específico.
  static void _removeUserAccountFromDb(User user){
    FirebaseDatabase db = FirebaseDatabase.instance;

    DatabaseReference userRef = db.reference()
        .child(FirebaseReferences.REFERENCE_USERS);

    DatabaseReference proRef = db.reference()
        .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);

    DatabaseReference relationshipRef = db.reference()
        .child(FirebaseReferences.REFERENCE_UF_CIDADES_SERVICOS_PROFISSIONAIS);

    if (user.professionalData != null){
      // removendo relacionamento com estado, cidades e servicos
      for (String city in user.professionalData.cidadesAtuantes){
        for(String serviceId in user.professionalData.servicosAtuantes){
          relationshipRef.child( user.professionalData.estadoAtuante )
              .child( city ).child( serviceId ).child( user.uid).remove();
        }
      }
      proRef.child(user.uid).remove();
    }

    userRef.child(user.uid).remove();

  }

  ///Remove toda a "conta do usuário", tanto seus dados do database
  ///quando sua autenticação.
  static Future<bool> _removeUserAccountFromAuthSystem( /*User user*/) async {

    FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();

    // Se estar logado com facebook acount
    if (fbUser.providerData[1].providerId.compareTo( _PROVIDER_ID_FACEBOOK ) == 0) {
       FacebookAccessToken accessToken = await FacebookLogin().currentAccessToken;

       await FirebaseAuth.instance.reauthenticateWithFacebookCredential(
           accessToken: accessToken.token);
       fbUser = await FirebaseAuth.instance.currentUser();
       return fbUser.delete()
           .then((_){
             return true;
           }).catchError((error){ print("Error $error"); return false;});
    }

    else{ // estar logado com firebase account
      //var preferences = await SharedPreferences.getInstance();
      UserRepository repository = UserRepository();
      await FirebaseAuth.instance.reauthenticateWithEmailAndPassword(
          email: repository.fbLogin,
          password: repository.fbPassword);

      fbUser = await FirebaseAuth.instance.currentUser();
      return fbUser.delete().then((_){
        SharedPreferencesUtility.clear();
        return true;
      }).catchError((error){ print("Error $error"); return false;});
    }

  }


  static Future<bool> removeUser(User user) async {
    var results = await _removeUserAccountFromAuthSystem();
    if (results){
      _removeUserAccountFromDb(user);
      return results;
    }
    return false;
  }

}
