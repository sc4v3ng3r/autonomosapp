import 'package:autonos_app/model/Service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:autonos_app/firebase/FirebaseReferences.dart';

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

    List<Service> services = List();
    servicesReference.orderByKey().onValue.listen( (event){
        Map<String, dynamic> mapOfMaps = Map.from( event.snapshot.value);

        mapOfMaps.values.forEach( (value) {
          services.add( Service.fromJson(Map.from(value) ));
        });

        onData(services);
    } )
      .onError( (error) {
        throw error;
    });

    return services;

  }


  //Método utilizado para inseriri servicos no db.
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

  /*
  *
  * {-LSK9pnMMl680YrXVKXo: {name: Tradutor}, -LSK9plUDNNpqZ5eAX5z: {name: Imobiliária} },
  *
  *
  *
  * */
}