
class ProfissionalData {

  String documento;
  String tipoPessoa;
  String telefone;
  String descricao;
  List<String> cidadesAtuantes;
  List<String> servicosAtuantes;
  bool emissorNotaFiscal;

  // talvez isso seja um node [Location]!
  double latitude;
  double longitude;
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

  Map<String, dynamic> toJson() => {
    UID: uid, // tavez nao fique aqui
    _DOCUMENTO : documento,
    _TIPO_PESSOA : tipoPessoa,
    _TELEFONE : telefone,
    _DESCRICAO : descricao,
    _CIDADES : cidadesAtuantes,
    _SERVICOS : servicosAtuantes,
    _NOTA_FISCAL : emissorNotaFiscal,
    //ambos podem virar um objeto especifico LOCALIZACAO, facilitara o rastreio!
    _LATITUDE : latitude,
    _LONGITUDE : longitude,
  };

  ProfissionalData.fromJson(Map<String, dynamic> json) :
      uid = json[UID],
      documento = json[_DOCUMENTO],
      tipoPessoa = json[_TIPO_PESSOA],
      telefone = json[_TELEFONE],
      descricao = json[_DESCRICAO],
      latitude = json[_LATITUDE],
      longitude = json[_LONGITUDE],
      emissorNotaFiscal = json[_NOTA_FISCAL],
      servicosAtuantes = List.from( json[_SERVICOS] ),
      cidadesAtuantes = List.from( json[_CIDADES] );
}