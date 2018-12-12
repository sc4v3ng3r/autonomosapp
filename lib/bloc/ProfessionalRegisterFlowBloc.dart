import 'dart:developer';

import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/model/Estado.dart';
import 'package:autonos_app/model/Service.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/model/ProfessionalData.dart';

class ProfessionalRegisterFlowBloc {


  ProfessionalData _professionalData = new ProfessionalData();
  ProfessionalData get currentData => _professionalData;

  void insertBasicProfessionalInformation(
    { @required String typePeople,
      @required String documentNumber,
      @required String phone,
      String documentPictures,
      @required String description}
      ){

    _professionalData.tipoPessoa = typePeople;
    _professionalData.documento = documentNumber;
    _professionalData.telefone = phone;
    _professionalData.descricao = description;
  }

  void insertLocationsAndServices( {
    @required Estado state,
    @required List<Cidade> yourCities,
    @required List<Service> yourServices } ){

      _professionalData.estadoAtuante =  state.sigla;

      yourCities.forEach( (cidade) {
        _professionalData.cidadesAtuantes.add( cidade.id );
      });

      yourServices.forEach( (service) {
        _professionalData.servicosAtuantes.add( service.id );
      });
  }

  void insertPaymentInfo( {
    @required bool emissorNotaFiscal,
    List<String> tiposPagamento

  }){

    _professionalData.emissorNotaFiscal = emissorNotaFiscal;

  }

  dispose(){

  }

}
/*
class ProfessionalRegisterFlowBlocProvider extends InheritedWidget {
  static final String BLOC_KEY = "ProfessionalRegisterFlowBloc_KEY";
  final _bloc = ProfessionalRegisterFlowBloc();

  ProfessionalRegisterFlowBlocProvider({Key key, Widget child}) :
      super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;



  static ProfessionalRegisterFlowBloc of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(ProfessionalRegisterFlowBlocProvider)
    as ProfessionalRegisterFlowBlocProvider)
        ._bloc;
  }

}*/