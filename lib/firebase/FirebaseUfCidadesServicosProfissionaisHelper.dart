import 'package:autonomosapp/model/Service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:autonomosapp/firebase/FirebaseReferences.dart';
import 'package:autonomosapp/model/ProfessionalData.dart';
import 'package:meta/meta.dart';

class FirebaseUfCidadesServicosProfissionaisHelper {

  static void writeIntoRelationship({@required String userId, ProfessionalData data}  ){
    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(FirebaseReferences.REFERENCE_UF_CIDADES_SERVICOS_PROFISSIONAIS)
        .child( data.estadoAtuante);

    for(String cityName in data.cidadesAtuantes){
      for(String serviceId in data.servicosAtuantes){
        ref.child(cityName).child(serviceId).child( userId ).set( userId )
            .catchError( (onError){
              print("FirebaseUfCidadesServicosProfissionaisHelper:: ${onError.toString()}");
        });
      }
    }
  }

  static Future<DataSnapshot> getProfessionalsIdsFromCityAndService({
    @required String estadoSigla, @required String cidadeNome,
    @required String serviceId }) {

    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(FirebaseReferences.REFERENCE_UF_CIDADES_SERVICOS_PROFISSIONAIS)
        .child( estadoSigla ).child( cidadeNome ).child( serviceId );

    return ref.once();
  }

  static void removeServicesFromProfessionalUser( String uid, List< Service > toRemove, ProfessionalData proData){
    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(FirebaseReferences.REFERENCE_UF_CIDADES_SERVICOS_PROFISSIONAIS)
        .child(proData.estadoAtuante);

    for (String city in proData.cidadesAtuantes)
      for(Service service in toRemove)
        ref.child( city).child( service.id ).child(uid).remove();
  }

}