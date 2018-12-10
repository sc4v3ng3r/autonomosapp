
class Estado implements Comparable<Estado>{

  static final String NOME = "nome";
  static final String SIGLA = "sigla";

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


}