import 'package:autonomosapp/firebase/FirebaseAuthHelper.dart';
import 'package:autonomosapp/firebase/FirebaseStorageHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUfCidadesServicosProfissionaisHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUserViewsHelper.dart';
import 'package:autonomosapp/model/ProfessionalData.dart';
import 'package:autonomosapp/utility/InputValidator.dart';
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
    /*DatabaseReference proRef = FirebaseDatabase.instance
        .reference()
        .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);
    */
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

      //DataSnapshot professionalData = await proRef.child(user.uid).once();
      /*if ((professionalData.value != null)) {
        print(
            "FirebaseUserHelper user $uid has pro data ${professionalData.value.toString()}");
        user.professionalData = ProfessionalData.fromSnapshot(professionalData);
      }*/

    }

    catch (ex) {
      print("FirebaseUserHelper ${ex.toString()}");
      throw ex;
    }

    return user;
  }

  /// Método usado para criar um conta de um simples  usuário no database
  static Future<User> createUserAccountData( FirebaseUser recentCreatedUser) async {

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

  static Future<void> updateUser({@required User user}) async{
    USERS_REFERENCE.child( user.uid).set( user.toJson() );
  }
  /// Registra no database os dados profissionais de um usuário específico.
  static Future<void> setUserProfessionalData( {
    @required String uid, @required ProfessionalData data}) {

    FirebaseUfCidadesServicosProfissionaisHelper.writeIntoRelationship(
      userId: uid,
      data:  data,
    );
    return USERS_REFERENCE.child(uid)
        .child(FirebaseReferences.REFERENCE_USER_PRO_DATA).set(data.toJson());
  }

  // TODO MELHORAR ESSE METODO
  ///Obtpem o usuário atualmente logado.
  static Future<User> currentLoggedUser() async {
    var user;
    try {
      FirebaseUser fbUser = await AUTH.currentUser();
      if (fbUser == null)
        return null;
      user = await readUserAccountData(fbUser);
    }
    catch (ex) {
      print("FirebaseUserHelper::" + ex.toString());
      throw ex;
    }
    return user;
  }

  /// Obtém os dados profissionais ProfessionalData do firebase dos usuários
  /// específicados pelos ID's.
  static Future< Map<String,dynamic> > getProfessionalUsers( List<String> UsersIds ) async {

    DatabaseReference ref = FirebaseDatabase.instance
        .reference();

    Map<String, dynamic> map = Map();
    for(String userId in UsersIds){
     var snapshot = await readUserNode(uid: userId);
     print(snapshot.value.toString());
      map.putIfAbsent( userId, () => snapshot.value );
    }
    return map;
  }

  /// Remove os dados do firebase real time database
  /// relacionados a um usuario específico.
  static void _removeUserAccountFromDb(User user) async {
    FirebaseDatabase db = FirebaseDatabase.instance;


    FirebaseUserViewsHelper.removeAllUserViews(userId: user.uid);

    DatabaseReference userRef = db.reference()
        .child(FirebaseReferences.REFERENCE_USERS);

    /*DatabaseReference proRef = db.reference()
        .child(FirebaseReferences.REFERENCE_PROFISSIONAIS);
    */
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
    }
    userRef.child(user.uid).remove();
  }

  ///Remove toda a "conta do usuário", tanto seus dados do database
  ///quando sua autenticação.
  
  static Future<bool> _removeUserAccountFromAuthSystem() async {
    UserRepository repository = UserRepository();
    FirebaseUser fbUser =  await FirebaseAuthHelper.reauthCurrentUser();

    await FirebaseStorageHelper.removeUserProfilePicture(
        userUid: repository.currentUser.uid);

    return fbUser.delete()
        .then((_){
          return true;
        }).catchError((error){ print("Error $error"); return false;});
  }

  /// Método utilizado para remover todos os dados do usuário do backend
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

  ///OBtém um usuário específico
  static Future<DataSnapshot> readUserNode( {@required String uid} ) async
     => USERS_REFERENCE.child(uid).once();
}
