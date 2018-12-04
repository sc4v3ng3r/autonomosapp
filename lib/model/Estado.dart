
class Estado {

  static final String NOME = "nome";
  static final String SIGLA = "sigla";

  //var id;
  var sigla;
  var nome;

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
    // TODO: implement toString
    return "$NOME:$nome $SIGLA: $sigla";
  }
}