import 'package:autonomosapp/firebase/FirebaseAuthHelper.dart';
import 'package:autonomosapp/firebase/FirebaseStorageHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUfCidadesServicosProfissionaisHelper.dart';
import 'package:autonomosapp/model/ProfessionalData.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/firebase/FirebaseReferences.dart';
import 'package:meta/meta.dart';

class FirebaseUserHelper {
  static final RATING_INIT_VALUE = 5.0;
  static final FirebaseAuth AUTH = FirebaseAuth.instance;
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

        var url = fbUser.photoUrl;

        if (url != null)
          CachedNetworkImageProvider( url );
      }

      DataSnapshot professionalData = await proRef.child(user.uid).once();
      if ((professionalData.value != null)) {
        print(
            "FirebaseUserHelper user $uid has pro data ${professionalData.value.toString()}");
        user.professionalData = ProfessionalData.fromSnapshot(professionalData);
      }

    }

    catch (ex) {
      print("FirebaseUserHelper ${ex.toString()}");
      throw ex;
    }

    return user;
  }

  static Future<User> writeUserAccountData(
      FirebaseUser recentCreatedUser) async {

    try {
      //print("Registrando conta no DB!");
      User user = new User(
        uid: recentCreatedUser.uid,
        email: recentCreatedUser.email,
        name: recentCreatedUser.displayName,
        picturePath: recentCreatedUser.photoUrl,
        rating: RATING_INIT_VALUE,
      );

      await USERS_REFERENCE.child(recentCreatedUser.uid).set(user.toJson());
      return user;

    } catch (ex) { throw ex; }
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
  static void _removeUserAccountFromDb(User user) async {
    FirebaseDatabase db = FirebaseDatabase.instance;

    DatabaseReference userRef = db.reference()
        .child(FirebaseReferences.REFERENCE_USERS);

    DatabaseReference proRef = db.reference()
        .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);

    DatabaseReference relationshipRef = db.reference()
        .child(FirebaseReferences.REFERENCE_UF_CIDADES_SERVICOS_PROFISSIONAIS);

    //esse pequeno trecho de codigo se repete na classe helper do relacionamento
    // estado -> cidade -> servico -> usuario
    if (user.professionalData != null){
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

  //TODO nao precisa mais de reauth aqui!! basta chamar reauh de AuthHelper e remover os dados!
  static Future<bool> _removeUserAccountFromAuthSystem() async {
    UserRepository repository = UserRepository();
    FirebaseUser fbUser =  await FirebaseAuthHelper.reAuthCurrentUser();

    await FirebaseStorageHelper.removeUserProfilePicture(
        userUid: repository.currentUser.uid);

    return fbUser.delete()
        .then((_){
          return true;
        }).catchError((error){ print("Error $error"); return false;});
  }

  static Future<bool> removeUser(User user) async {
    var results = await _removeUserAccountFromAuthSystem();
    if (results){
      _removeUserAccountFromDb(user);
      return results;
    }
    return false;
  }

  static Future<bool> updateFirebaseUserInfo({
    @required FirebaseUser currentUser, String displayName = "", String photoUrl }) async {

    UserUpdateInfo info = UserUpdateInfo();

    info.displayName = displayName;

    if (photoUrl!=null)
      info.photoUrl = photoUrl;

    try{
      await currentUser.updateProfile( info );
      return true;
    }

    catch (ex){
      print("FirebaseUserHelper::updateFirebaseUserInfo() $ex");
      return false;
    }
  }

  static Future<DataSnapshot> readUserNode({@required String uid}) async
     => USERS_REFERENCE.child(uid).once();
}
