
class ProfessionalData {

  String documento;
  String tipoPessoa;
  String telefone;
  String descricao;
  String estadoAtuante;
  List<String> cidadesAtuantes = new List();
  List<String> servicosAtuantes = new List();
  List<String> formasPagamento = new List();

  bool emissorNotaFiscal;

  // talvez isso seja um node [Location]!
  double latitude =0.0;
  double longitude = 0.0;
  String uid;

  static final String UID = "uid";
  static final String _DOCUMENTO = "documento";
  static final String _TIPO_PESSOA = "tipoPessoa";
  static final String _TELEFONE = "telefone";
  static final String _DESCRICAO = "descricao";
  static final String _CIDADES = "cidadesAtuantes";
  static final String _SERVICOS = "servicosAtuantes";
  static final String _NOTA_FISCAL = "emissorNotaFiscal";
  static final String _LATITUDE = "latitude";
  static final String _LONGITUDE = "longitude";
  static final String _FORMAS_PAGAMENTO = "formas_pagamento";
  ProfessionalData();

  Map<String, dynamic> toJson() => {
    UID: uid, // tavez nao fique aqui
    _DOCUMENTO : documento,
    _TIPO_PESSOA : tipoPessoa,
    _TELEFONE : telefone,
    _DESCRICAO : descricao,
    _CIDADES : cidadesAtuantes,
    _SERVICOS : servicosAtuantes,
    _NOTA_FISCAL : emissorNotaFiscal,
    _FORMAS_PAGAMENTO : formasPagamento,
    //TODO ambos podem virar um objeto especifico LOCALIZACAO, facilitara o rastreio!
    _LATITUDE : latitude,
    _LONGITUDE : longitude,
  };

  ProfessionalData.fromJson(Map<String, dynamic> json) :
      uid = json[UID],
      documento = json[_DOCUMENTO],
      tipoPessoa = json[_TIPO_PESSOA],
      telefone = json[_TELEFONE],
      descricao = json[_DESCRICAO],
      latitude = json[_LATITUDE],
      longitude = json[_LONGITUDE],
      emissorNotaFiscal = json[_NOTA_FISCAL],
      servicosAtuantes = List.from( json[_SERVICOS] ),
      formasPagamento = List.from( json[_FORMAS_PAGAMENTO] ),
      cidadesAtuantes = List.from( json[_CIDADES] );


  @override
  String toString() {
    return "$UID: $uid\n"
        "$_TIPO_PESSOA: $tipoPessoa\n"
        "$_DOCUMENTO $documento\n"
        "$_TELEFONE: $telefone";
  }
}