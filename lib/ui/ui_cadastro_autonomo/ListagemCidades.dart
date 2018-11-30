import 'package:flutter/material.dart';

class ListagemCidades extends StatefulWidget {
  final String _nomeEstado;
  final List<String> _cidades;

  ListagemCidades({String nome, @required List cidades})
      : this._nomeEstado = nome,
        this._cidades = cidades;

  @override
  ListagemCidadesState createState() =>
      ListagemCidadesState(_nomeEstado, _cidades);
}

class ListagemCidadesState extends State<ListagemCidades> {
  final String _nomeEstado;
  final List<String> _cidades;

  ListagemCidadesState(String nomeEstado, @required List cidades)
      : this._nomeEstado = nomeEstado,
        this._cidades = cidades;
  TextEditingController controller = new TextEditingController();

  var colorCard;
  List<CidadeItem> _cidadeList = new List();
  List<String> _cidadesSelecionadas = new List();
//  CidadeItem cidadeItem;
  void _criaListaCidade(){
    for(String nomeCidade in _cidades){
      CidadeItem c = new CidadeItem(nomeCidade, Colors.white);
      _cidadeList.add(c);
    }
  }


  @override
  void initState() {
    _criaListaCidade();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.red[400],
        title: Text(
          '$_nomeEstado',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          new Container(
              child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                    color: Colors.red[400],
                    child: Padding(
                      padding: EdgeInsets.all(.0),
                      child: Card(
                        elevation: 8.0,
                        color: Colors.white,
                        child: ListTile(
                          leading: Icon(
                            Icons.search,
                            color: Colors.red[400],
                          ),
                          title: TextField(
                            controller: controller,
                            decoration: new InputDecoration(
                                border: InputBorder.none, hintText: 'Busca'),
                          ),
                          trailing: new IconButton(
                              icon: Icon(Icons.cancel, color: Colors.black87),
                              onPressed: () {
                                controller.clear();
                              }),
                        ),
                      ),
                    )),
              )
            ],
          )),
          new Expanded(child: new ListView.builder(
            itemBuilder: (context, index) {
              return new Card(
                color: _cidadeList[index].corItem,
                child: new ListTile(
                  onTap: (){
                    setState(() {
                      if(_cidadeList[index].corItem == Colors.white){
                      _cidadeList[index].setCor(Colors.green[200]);
                      _cidadesSelecionadas.add(_cidadeList[index].nomeCidade);
                      }
                      else{
                        _cidadeList[index].setCor(Colors.white);
                        _cidadesSelecionadas.remove(_cidadeList[index].nomeCidade);
                      }
                    });

                  },
                title: Text('${_cidadeList[index].nomeCidade}'),
                ),
              );
//              return ListTile(
//                title: Text('${_cidades[index]}'),
//              );
            },
            itemCount: _cidades.length,
          )
          )
        ],
//
      ),
    );
  }
}

class CidadeItem{
  String nomeCidade;
  var corItem;

  CidadeItem(String nome, var corItem):
      this.nomeCidade = nome,
      this.corItem = corItem;

  void setCor(var c){
    corItem = c;
  }

  void changeTextColor(){
//    if(corItem ==  )
  }

  Text getText(){
    return Text(nomeCidade);
  }

  Color getColor(){
    return corItem;
  }
}
