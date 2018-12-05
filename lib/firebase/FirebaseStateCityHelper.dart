import 'package:firebase_database/firebase_database.dart';
import 'package:autonos_app/model/Estado.dart';
import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/firebase/FirebaseReferences.dart';
import 'package:flutter/foundation.dart';

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

  static Future< List<Cidade> > getCityListByState(String uf) async {
    List<Cidade> cityList = new List();
    DatabaseReference cityRef = FirebaseDatabase.instance
        .reference().child( FirebaseReferences.REFERENCE_ESTADOS_CIDADES );
    cityRef.child(uf).once().then(
            (dataSnapshot) {

              /*Map<String, dynamic> citiesMap = Map.from( dataSnapshot.value);

              citiesMap.forEach( (key, value) {
                  Cidade city = Cidade.fromJson(Map.from(value));
                  city.id = key; // id da cidade eh o nó raiz da cidade
                  city.uf = dataSnapshot.key.toString();// a sigla do estado eh  Nó raiz do snapshot
                  cityList.add(city);
              });

              return cityList;*/
              return compute(_parseData, dataSnapshot);
            } ).catchError(

            (onError) {
              print(onError);
              throw onError;
            });

    return cityList;
  }

  static List<Cidade> _parseData (DataSnapshot dataSnapshot) {
    Map<String, dynamic> citiesMap = Map.from( dataSnapshot.value);
    List<Cidade> cityList = new List();

    citiesMap.forEach( (key, value) {
      Cidade city = Cidade.fromJson(Map.from(value));
      city.id = key; // id da cidade eh o nó raiz da cidade
      city.uf = dataSnapshot.key.toString();// a sigla do estado eh  Nó raiz do snapshot
      cityList.add(city);
    } );

    return cityList;
  }

  static List<Cidade> getCitiesFrom(String state, Function onData(List<Cidade> list)){
    List<Cidade> list = new List();

    DatabaseReference cityRef = FirebaseDatabase.instance
        .reference().child( FirebaseReferences.REFERENCE_ESTADOS_CIDADES );

    cityRef.child(state).onValue.listen( (event) {
      print(event.snapshot.value);

    });

    return list;
  }
}