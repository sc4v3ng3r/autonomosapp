import 'package:firebase_database/firebase_database.dart';
import 'package:autonos_app/firebase/FirebaseReferences.dart';
import 'package:autonos_app/model/ProfessionalData.dart';
import 'package:meta/meta.dart';

class FirebaseUfCidadesServicosProfissionaisHelper {

  static void writeIntoRelationship(ProfessionalData data){
    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(FirebaseReferences.REFERENCE_UF_CIDADES_SERVICOS_PROFISSIONAIS)
        .child( data.estadoAtuante);

    for(String cityName in data.cidadesAtuantes){
      for(String serviceId in data.servicosAtuantes){
        ref.child(cityName).child(serviceId).child( data.uid).set( data.uid )
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
        /*
        .then( (snapshot) {
      if (snapshot.value != null){
        print("data recovered ${snapshot.value.toString()}");
      }
      else print("NULL SNAPSHOT");
    }
    ).catchError( (error) { throw error; } );
    */
  }

}