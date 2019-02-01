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

  static Future< List<Service> > getAllServices( void onData( List<Service> data) ) async {
    DatabaseReference servicesReference = FirebaseDatabase.instance
        .reference().child(FirebaseReferences.REFERENCE_SERVICOS);

    List<Service> services;
    servicesReference.orderByKey().onValue.listen( (event){
        /*
        Map<String, dynamic> mapOfMaps = Map.from( event.snapshot.value);
        //print(event.snapshot.key);
        mapOfMaps.values.forEach( (value) {

          services.add( Service.fromJson( Map.from(value) ));
        });*/
        services =  _parseData(event.snapshot);
        onData(services);

    } )
      .onError( (error) {
        throw error;
    });

    return services;
  }


  static Stream<Event> getServiceById(String id) {
    DatabaseReference servicesReference = FirebaseDatabase.instance
        .reference().child(FirebaseReferences.REFERENCE_SERVICOS);
    return servicesReference.child( id ).onValue;

  }

  static List<Service> _parseData(DataSnapshot dataSnapshot) {
    List<Service> services =new List();
    Map<String, dynamic> mapOfMaps = Map.from( dataSnapshot.value);
    //print(event.snapshot.key);
    mapOfMaps.values.forEach( (value) {

      services.add( Service.fromJson( Map.from(value) ));
    });

    return services;

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