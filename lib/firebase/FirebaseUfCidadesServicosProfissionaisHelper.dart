import 'package:firebase_database/firebase_database.dart';
import 'package:autonos_app/firebase/FirebaseReferences.dart';
import 'package:autonos_app/model/ProfessionalData.dart';

class FirebaseUfCidadesServicosProfissionaisHelper {

  static void writeIntoRelationship(ProfessionalData data){
    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(FirebaseReferences.REFERENCE_UF_CIDADES_SERVICOS_PROFISSIONAIS)
        .child( data.estadoAtuante);

    for(String cityId in data.cidadesAtuantes){
      for(String serviceId in data.servicosAtuantes){
        ref.child(cityId).child(serviceId).child( data.uid).set( data.uid )
            .catchError( (onError){
              print("FirebaseUfCidadesServicosProfissionaisHelper:: ${onError.toString()}");
        });
      }
    }

  }
}