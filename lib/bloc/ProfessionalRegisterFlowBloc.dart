import 'dart:developer';
import 'dart:io';

import 'package:autonomosapp/model/Cidade.dart';
import 'package:autonomosapp/model/Estado.dart';
import 'package:autonomosapp/model/Location.dart';
import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/model/ProfessionalData.dart';


class ProfessionalRegisterFlowBloc {


  ProfessionalData _professionalData = new ProfessionalData();
  ProfessionalData get currentData => _professionalData;

  Map<PictureTypeCode, String> _profilePicture;
  Map<PictureTypeCode, String> get profilePictureInfo => _profilePicture;

  File _rgFrente;
  File get rgFrente => _rgFrente;
  File _rgVerso;
  File get rgFundo => _rgVerso;

  File _fotoComRg;
  File get fotoComRG => _fotoComRg;

  bool hasDocuments() =>
    ( (_fotoComRg !=null) && (_rgFrente !=null) && (_rgVerso != null)  );


  void insertBasicProfessionalInformation(
    { @required String typePeople,
      @required String documentNumber,
      @required String phone,
      @required Map<PictureTypeCode, String> profilePicture,
      String documentPictures,
      @required String description}
      ){

    _professionalData.tipoPessoa = typePeople;
    _professionalData.documento = documentNumber;
    _professionalData.telefone = phone;
    _professionalData.descricao = description;
    _profilePicture = profilePicture;
  }

  void insertRgFrenteFoto(File rgFrente) => _rgFrente = rgFrente;
  void insertRgVersoFoto(File rgVerso) => _rgVerso = rgVerso;
  void insertFotoPessoalComRg(File fotoComRg) => _fotoComRg = fotoComRg;

  void insertLocationsAndServices( {
    @required final Estado state,
    @required final List<Cidade> yourCities,
    @required final List<Service> yourServices,
    @required final String professionalName,
    @required final Location currentLocation} ){

      _professionalData.estadoAtuante =  state?.sigla;
      _professionalData.latitude = currentLocation?.latitude;
      _professionalData.longitude = currentLocation?.longitude;

      _professionalData.cidadesAtuantes.clear();
      yourCities.forEach( (cidade) {
        _professionalData.cidadesAtuantes.add( cidade.nome );
      });

      _professionalData.servicosAtuantes.clear();
      yourServices.forEach( (service) {
        _professionalData.servicosAtuantes.add( service.id );
      });
  }

  void insertPaymentInfo( {
    @required bool emissorNotaFiscal,
    List<String> tiposPagamento

  }){
    _professionalData.formasPagamento = tiposPagamento;
    _professionalData.emissorNotaFiscal = emissorNotaFiscal;
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