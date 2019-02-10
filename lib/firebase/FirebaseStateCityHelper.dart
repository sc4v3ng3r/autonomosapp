import 'package:firebase_database/firebase_database.dart';
import 'package:autonomosapp/model/Estado.dart';
import 'package:autonomosapp/firebase/FirebaseReferences.dart';

class FirebaseStateCityHelper {

  static Future< List<Estado> > getStateList() async {
    DatabaseReference stateRef = FirebaseDatabase.instance
        .reference().child( FirebaseReferences.REFERENCE_ESTADOS );

    List<Estado> stateList = new List();

    stateRef.orderByKey().once().then(
            ( dataSnapshot ) {
              Map<String, dynamic> statesMap = Map.from(dataSnapshot.value);
              statesMap.forEach( (key, value) {
                Estado state = Estado.fromJson( Map.from( value) );
                state.sigla = key;
                stateList.add(state);
              } );

              return stateList;

            } ).catchError(

            ( onError ) {
              throw onError;
            });

    return stateList;
  }

  static Future<DataSnapshot> getCitiesFrom(String state) async {

    DatabaseReference cityRef = FirebaseDatabase.instance
        .reference().child( FirebaseReferences.REFERENCE_ESTADOS_CIDADES );

    return  cityRef.child(state).once();
  }
}