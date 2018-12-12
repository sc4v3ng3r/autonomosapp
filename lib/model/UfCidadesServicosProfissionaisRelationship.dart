import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UfCidadesServicosProfissionaisRelationship {
  String estadoSigla;
  String cidadeId;
  String servicoId;
  List<String> idsUsuario;

  static final String _ESTADO_SIGLA = "estadoSigla";
  static final String _CIDADE_ID = "cidadesIs";
  static final String _SERVICO_ID = "servicosAtuantes";
  static final String _IDS_USUARIO = "idUsuario";

  UfCidadesServicosProfissionaisRelationship({ @required String estadoSigla,
    @required String cidadeId, @required String servicoId,
    @required List<String> idsUsuario}) :
        this.estadoSigla = estadoSigla,
        this.cidadeId = cidadeId,
        this.servicoId = servicoId,
        this.idsUsuario = idsUsuario;

  Map<String,dynamic> toJson() => {
    _ESTADO_SIGLA: this.estadoSigla,
    _CIDADE_ID: this.cidadeId,
    _SERVICO_ID : this.servicoId,
    _IDS_USUARIO : this.idsUsuario,
  };

  UfCidadesServicosProfissionaisRelationship.fromSnapshot( DataSnapshot snapshot ) :
      estadoSigla = snapshot.value[_ESTADO_SIGLA],
      cidadeId = snapshot.value[_CIDADE_ID],
      servicoId = snapshot.value[_SERVICO_ID],
      idsUsuario = List.from( snapshot.value[_IDS_USUARIO] );
}