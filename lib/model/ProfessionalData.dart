
import 'package:firebase_database/firebase_database.dart';

class ProfessionalData {

  String documento;
  String tipoPessoa;
  String telefone;
  String descricao;
  String estadoAtuante;
  String nome;
  List<String> cidadesAtuantes = new List();
  List<String> servicosAtuantes = new List();
  List<String> formasPagamento = new List();
  bool emissorNotaFiscal;
  // talvez isso seja um node [Location]!
  double latitude =0.0;
  double longitude = 0.0;
  String uid;
  String photoUrl;

  static final String UID = "uid";
  static final String _NOME = "nome";
  static final String _DOCUMENTO = "documento";
  static final String _TIPO_PESSOA = "tipoPessoa";
  static final String _TELEFONE = "telefone";
  static final String _DESCRICAO = "descricao";
  static final String _CIDADES = "cidadesAtuantes"; // array
  static final String _SERVICOS = "servicosAtuantes"; // array
  static final String _NOTA_FISCAL = "emissorNotaFiscal";
  static final String _LATITUDE = "latitude";
  static final String _LONGITUDE = "longitude";
  static final String _FORMAS_PAGAMENTO = "formasPagamento"; // array
  static final String _ESTADO_ATUANTE = "estadoAtuante";
  static final String _PHOTO_URL = "photoUrl";

  ProfessionalData();

  Map<String, dynamic> toJson() => {
    UID: uid, // tavez nao fique aqui
    _NOME : nome,
    _DOCUMENTO : documento,
    _TIPO_PESSOA : tipoPessoa,
    _TELEFONE : telefone,
    _DESCRICAO : descricao,
    _ESTADO_ATUANTE : estadoAtuante,
    _CIDADES : cidadesAtuantes,
    _SERVICOS : servicosAtuantes,
    _NOTA_FISCAL : emissorNotaFiscal,
    _FORMAS_PAGAMENTO : formasPagamento,
    _PHOTO_URL :photoUrl,
    //TODO ambos podem virar um objeto especifico LOCALIZACAO, facilitara o rastreio!
    _LATITUDE : latitude,
    _LONGITUDE : longitude,
  };

  ProfessionalData.fromJson(Map<String, dynamic> json) :
      uid = json[UID],
      nome = json[_NOME],
      documento = json[_DOCUMENTO],
      tipoPessoa = json[_TIPO_PESSOA],
      telefone = json[_TELEFONE],
      descricao = json[_DESCRICAO],
      latitude = json[_LATITUDE],
      longitude = json[_LONGITUDE],
      photoUrl = json[_PHOTO_URL],
      estadoAtuante = json[_ESTADO_ATUANTE],
      emissorNotaFiscal = json[_NOTA_FISCAL],
      servicosAtuantes = List.from( json[_SERVICOS] ),
      formasPagamento = List.from( json[_FORMAS_PAGAMENTO] ),
      cidadesAtuantes = List.from( json[_CIDADES] );

  ProfessionalData.fromSnapshot( DataSnapshot snapshot ) :
      uid = snapshot.value[UID],
      nome= snapshot.value[_NOME],
      documento = snapshot.value[_DOCUMENTO],
      photoUrl = snapshot.value[_PHOTO_URL],
      tipoPessoa = snapshot.value[_TIPO_PESSOA],
      telefone = snapshot.value[_TELEFONE],
      descricao = snapshot.value[_DESCRICAO],
      emissorNotaFiscal = snapshot.value[_NOTA_FISCAL],
      estadoAtuante = snapshot.value[_ESTADO_ATUANTE],
      latitude = double.parse( snapshot.value[_LATITUDE].toString() ),
      longitude = double.parse(snapshot.value[_LONGITUDE].toString() ),
      servicosAtuantes = List.from( snapshot.value[_SERVICOS] ),
      cidadesAtuantes = List.from( snapshot.value[_CIDADES] ),
      formasPagamento = List.from( snapshot.value[_FORMAS_PAGAMENTO]);
  
  @override
  String toString() {
    return "$UID: $uid\n"
        "$_TIPO_PESSOA: $tipoPessoa\n"
        "$_DOCUMENTO $documento\n"
        "$_TELEFONE: $telefone\n"
        "$_ESTADO_ATUANTE $estadoAtuante\n"
        "$_LATITUDE: $latitude\n"
        "$_LONGITUDE: $longitude";
  }
}