
class Estado implements Comparable<Estado>{

  static final String NOME = "nome";
  static final String SIGLA = "sigla";
  static const String KEY_NONE = "NONE";
  static const Map<String, String> STATES_MAP = const {
    KEY_NONE: "Selecione seu Estado",
    "AC": "Acre",
    "AL": "Alagoas",
    "AM": "Amazonas",
    "AP": "Amapá",
    "BA": "Bahia",
    "CE": "Ceará",
    "DF": "Distrito Federal",
    "ES": "Espírito Santo",
    "GO": "Goiás",
    "MA": "Maranhão",
    "MG": "Minas Gerais",
    "MS": "Mato Grosso do Sul",
    "MT": "Mato Grosso",
    "PA": "Pará",
    "PB": "Paraíba",
    "PE": "Pernambuco",
    "PI": "Piauí",
    "PR": "Paraná",
    "RJ": "Rio de Janeiro",
    "RN": "Rio Grande do Norte",
    "RO": "Rondônia",
    "RR": "Roraima",
    "RS": "Rio Grande do Sul",
    "SC": "Santa Catarina",
    "SE": "Sergipe",
    "SP": "São Paulo",
    "TO": "Tocantins"
  };

  //var id;
  String sigla;
  String nome;

  Estado(this.nome);

  Estado.fromJson( Map<String, dynamic> json ) :
    //id = json[ID],
    //sigla = json[SIGLA],
    nome = json[NOME];

  Map<String, dynamic> toJson () => {
    NOME: nome,
    //SIGLA: sigla
  };

  @override
  String toString() {
    return "$NOME:$nome $SIGLA: $sigla";
  }

  @override
  int compareTo(Estado other) {
    return this.nome.compareTo( other.nome );
  }


  static String keyOfState(String stateName){
    String result = KEY_NONE;
    STATES_MAP.forEach((key, value) {
      if (value.compareTo(stateName ) == 0){
        result = key;
        return;
      }
    });

    return result;
  }
}