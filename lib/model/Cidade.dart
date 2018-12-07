class Cidade implements Comparable<Cidade> {

  static final String ID = "id";
  static final String NOME = "nome";
  static final String UF = "uf";

  var id;
  String nome;
  var uf;

  Cidade(this.id, this.nome, this.uf);

  Cidade.fromJson(Map<String, dynamic> json) :
      //id = json[ID],
      nome = json[NOME];


  Map<String, dynamic> toJson () =>{
    //ID : id,
    NOME : nome,
    //UF: uf,
  };

  @override
  String toString() {
    // TODO: implement toString
    return "$NOME: $nome $UF: $uf $ID: $id";
  }

  @override
  bool operator ==(other) {
    return other is Cidade && ( (id.toString().compareTo(other.id.toString() )) == 0);
  }

  @override
  int compareTo(Cidade other) {
    return this.nome.compareTo( other.nome);
  }


}