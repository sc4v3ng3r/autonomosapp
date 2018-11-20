import 'package:firebase_database/firebase_database.dart';
import 'package:autonos_app/firebase/FirebaseReferences.dart';

class FirebaseServicesHelper {

  static Future<List<String>> getServicesByArea(String subarea, void onData( List<String> data) ) async {
    DatabaseReference reference = FirebaseDatabase.instance.reference()
      .child(FirebaseReferences.REFERENCE_AREA)
        .child(subarea).child(FirebaseReferences.REFERENCE_SERVICOS);

    List<String> services = List();
     reference.onValue.listen( (event) {
      services = List.from( event.snapshot.value );
      onData(services);
    });

    return services;
  }

  /*
  static Future<List<Service>> getServices(String subarea) async {
    DatabaseReference reference = FirebaseDatabase.instance.reference()
        .child(FirebaseReferences.REFERENCE_AREA)
        .child(subarea).child(FirebaseReferences.REFERENCE_SERVICOS);
    List<Service> serviceList = new List();

    try {
      //TODO SO ESTAR LENDO UMA UNICA VEZ!!
      DataSnapshot snapshot = await reference.once();
      if (snapshot!=null){

        List<String> services = List.from( snapshot.value );
        Iterator it = services.iterator;
        int index = 0;
        while(it.moveNext()){
          serviceList.add(  Service.fromString(index, it.current.toString()) );
        }
        print("FirebaseServicesHelper:: TOTAL: ${serviceList.length}");
      }
    }

    catch (ex){
      print( "FirebaseServicesHelper::" + ex.toString());
      throw ex;
    }
    return serviceList;
  }*/
}