import 'package:autonomosapp/model/Service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:autonomosapp/firebase/FirebaseReferences.dart';

class FirebaseServicesHelper {

  static Future<List<String>> getServicesByArea(String subarea, void onData( List<String> data) ) async {
    DatabaseReference reference = FirebaseDatabase.instance.reference()
      .child(FirebaseReferences.REFERENCE_AREA)
        .child(subarea).child( FirebaseReferences.REFERENCE_SERVICOS );

    List<String> services = List();
     reference.onValue.listen( ( event ) {
      services = List.from( event.snapshot.value );
      onData(services);
      insertServices(services);
    });

    return services;
  }

  static Future<DataSnapshot> getAllServices() async {
    DatabaseReference servicesReference = FirebaseDatabase.instance
        .reference().child(FirebaseReferences.REFERENCE_SERVICOS);
    return servicesReference.orderByKey().once();
  }


  static Stream<Event> getServiceById(String id) {
    DatabaseReference servicesReference = FirebaseDatabase.instance
        .reference().child(FirebaseReferences.REFERENCE_SERVICOS);
    return servicesReference.child( id ).onValue;

  }


  /// Método utilizado para inseriri servicos no db.
  static Future<bool> insertServices(List<String> stringServices) async {
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    DatabaseReference servicesRef = reference.child( FirebaseReferences.REFERENCE_SERVICOS);

    Service service;

    for (String serviceName in stringServices){
      var localRef = servicesRef.push();

      print("GENERATED KEY: ${localRef.key}");
       service = new Service(localRef.key, serviceName);

      localRef.set(  service.toJson() ) .then( (value) {})
          .catchError( (error) {
        print("Failed to insert data ${error.toString()}");
      }) ;
    }

    return true;

  }

}