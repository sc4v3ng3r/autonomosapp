import 'dart:io';
import 'dart:convert';
import 'package:autonos_app/model/Cidade.dart';

import 'package:autonos_app/model/Estado.dart';

/**
 *
 * Script De testes para realizar mineração dos dados do IBGE.
 * ELe faz as consultas ao sistema do IBGE e exibe os resultados em tela.
 *
 * Esse algoritmo foi utilizado como algoritimo base para  aplicação
 * android fazer a mineração dos dados p/ o firebase.
 *
 * */


void main() async {

  //FirebaseDatabase db = FirebaseDatabase.instance;
  //DatabaseReference estadosRef = db.reference().child("estados");
  //DatabaseReference cidadesReference = db.reference().child("estados_cidades");

  String uriEstados = "https://servicodados.ibge.gov.br/api/v1/localidades/estados/";
  var contentType = "application/json; charset=UTF-8";
  //List<Estado> estadoLista = new List();

  HttpClient client = new HttpClient();

  print("Making server request...");
  HttpClientRequest request = await client.getUrl(Uri.parse(uriEstados));
  print("setting headers");
  request.headers.set("Content-Type", contentType);

  print("Wating response...");
  HttpClientResponse response = await request.close();

  await for (var contents in response.transform( Utf8Decoder()) ){

    List<dynamic> stateList = json.decode(contents);

    for (dynamic listItem in stateList) {
      // ou adiciona no firebase
      Estado estado = Estado.fromJson(listItem);
      estado.sigla = listItem["sigla"];
      String currentStateId =  listItem["id"].toString();

      print("=====================================================================");
      print("$estado  ID: " + currentStateId);
      // insere estado no firebase
      //await estadosRef.child(estado.sigla).set(estado.toJson()); //.push().set( estado.toJson());

      print("getting cities of ${estado.nome}");
      request = await client.getUrl( Uri.parse( "$uriEstados $currentStateId/municipios" ));
      request.headers.set("Content-Type", contentType);
      response = await request.close();

      await for (var content in (response.transform( Utf8Decoder()).transform(json.decoder)) ) {
        List<dynamic> jsonList = List.from( content );
        for(Map<String, dynamic> jsonData in jsonList){
          Cidade city = Cidade.fromJson(jsonData);// obtem o nome,
          city.id = jsonData['id'];
          city.uf = estado.sigla; // sigla

          //await cidadesReference.child( city.uf ).child(  city.id.toString() ).set( city.toJson() );
          //insere no firebase
          print(city);
        }
        print("=====================================================================\n");
      }
    }

  }






  /*
  String uriEstados = "https://servicodados.ibge.gov.br/api/v1/localidades/estados/";
  var contentType = "application/json; charset=UTF-8";
  //List<Estado> estadoLista = new List();

  HttpClient client = new HttpClient();

  print("Making server request...");
  HttpClientRequest request = await client.getUrl(Uri.parse(uriEstados));
  print("setting headers");
  request.headers.set("Content-Type", contentType);

  print("Wating response...");
  HttpClientResponse response = await request.close();

  await for (var contents in response.transform( Utf8Decoder()) ){

    List<dynamic> stateList = json.decode(contents);

    for (dynamic listItem in stateList) {
      // ou adiciona no firebase
      Estado estado = Estado.fromJson(listItem);

      print("=====================================================================");
      // insere estado no firebase

      print("getting cities of ${estado.nome}");

      //TODO o id do estado eh necessario para a mineracao!
      //request = await client.getUrl( Uri.parse( "$uriEstados ${estado.id}/municipios" ));
      request.headers.set("Content-Type", contentType);
      response = await request.close();

      await for (var content in (response.transform( Utf8Decoder()).transform(json.decoder)) ) {
        List<dynamic> jsonList = List.from( content );
        for(Map<String, dynamic> jsonData in jsonList){
          Cidade city = Cidade.fromJson( jsonData );
          city.uf = estado.sigla;
          //insere no firebase
          print(city);
        }
        print("=====================================================================\n");
      }
    }

  }*/
}

/**
 *
 * {
 *  estados : {
 *    ""
 *
 *  }
 *
 *
 *
 * }
 *
 *
 *
 * */