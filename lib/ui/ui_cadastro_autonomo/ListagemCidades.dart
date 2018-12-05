import 'package:autonos_app/model/Estado.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/bloc/CitiesBloc.dart';

class ListagemCidades extends StatefulWidget {
  final List<String> _cidadesConfirmadas;
  final Estado _estado;

  ListagemCidades(
      {List cidadesConfirmadas, @required Estado estado} )
      : this._cidadesConfirmadas = cidadesConfirmadas,
        this._estado = estado;

  @override
  ListagemCidadesState createState() =>
      ListagemCidadesState();
}

class ListagemCidadesState extends State<ListagemCidades> {

  ListagemCidadesState();

  TextEditingController controller = new TextEditingController();

  var colorCard;
  List<CidadeItem> _cidadeList = new List();
  List<String> _cidadesSelecionadas = new List();
  final CitiesBloc _bloc = CitiesBloc();

  @override
  void dispose() {
    _bloc.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  /*
  void _criaListaCidade() {
    for (String nomeCidade in _cidades) {
      CidadeItem c;
      if (_cidadesConfirmadas != null) {
        if (_cidadesConfirmadas.contains(nomeCidade)) {
          c = new CidadeItem(nomeCidade, Colors.green[200]);
          _cidadesSelecionadas.add(nomeCidade);
        } else
          c = new CidadeItem(nomeCidade, Colors.white);
      } else
        c = new CidadeItem(nomeCidade, Colors.white);
      _cidadeList.add(c);
    }
  }*/

  @override
  void initState() {
    _bloc.getCity( widget._estado.sigla);
    super.initState();
  }

  Widget _confirmButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        SnackBar(content: Text('abc'));
        Navigator.of(context).pop(_cidadesSelecionadas);
      },
      icon: Icon(
        Icons.add,
        color: Colors.green[200],
      ),
    );
  }

  Widget _iconButton(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          _voltarDialog(context);
        });
  }

  AlertDialog _voltarDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Alerta!'),
      content: Text('Tem certeza que você deseja voltar?'),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var floatActionButton = FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pop( _cidadesSelecionadas );
      },
      foregroundColor: Colors.red,
      elevation: 8.0,
      backgroundColor: Colors.teal,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );

    var appBar = AppBar(
      actions: <Widget>[
        _confirmButton(context),
//          Icon(Icons.done,color: Colors.green[200],),
      ],
      elevation: 0.0,
      backgroundColor: Colors.red[300],
      title: Text(
        '${this.widget._estado.nome}',
        style: TextStyle(color: Colors.white),
      ),
    );

     var scaffold = Scaffold(
      appBar: appBar,
      floatingActionButton: floatActionButton,

      body: Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              Flexible(
                child: Container(
                    color: Colors.red[300],
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
                            onChanged: _onBuscaItem,
                            controller: controller,
                            decoration: new InputDecoration(
                                border: InputBorder.none, hintText: 'Busca'),
                          ),
                          trailing: new IconButton(
                              icon: Icon(Icons.cancel, color: Colors.black87),
                              onPressed: () {
                                controller.clear();
                                _onBuscaItem('');
                              }),
                        ),
                      ),
                    ),
                ),
              ),
            ],
          ),

          new Expanded(
              child: _searchItens.length != 0 || controller.text.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _searchItens.length,
                      itemBuilder: (context, index) {
                        return new Card(
                          color: _searchItens[index].corItem,
                          child: new ListTile(
                            onTap: () {
                              setState(() {
                                if (_searchItens[index].corItem ==
                                    Colors.white) {
                                  _searchItens[index].setCor(Colors.green[200]);
                                  _cidadesSelecionadas
                                      .add(_searchItens[index].nomeCidade);
                                } else {
                                  _searchItens[index].setCor(Colors.white);
                                  _cidadesSelecionadas
                                      .remove(_searchItens[index].nomeCidade);
                                }
                              });
                            },
                            title: Text('${_searchItens[index].nomeCidade}'),
                          ),
                        );
//              );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _cidadeList.length,
                      itemBuilder: (context, index) {
                        return new Card(
                          color: _cidadeList[index].corItem,
                          child: new ListTile(
                            onTap: () {
                              setState(() {
                                if (_cidadeList[index].corItem ==
                                    Colors.white) {
                                  _cidadeList[index].setCor(Colors.green[200]);
                                  _cidadesSelecionadas
                                      .add(_cidadeList[index].nomeCidade);
                                } else {
                                  _cidadeList[index].setCor(Colors.white);
                                  _cidadesSelecionadas
                                      .remove(_cidadeList[index].nomeCidade);
                                }
                              });
                            },
                            title: Text('${_cidadeList[index].nomeCidade}'),
                          ),
                        );
//              );
                      },
                    )),
        ],
      ),
    );



     return scaffold;
  }

  List<CidadeItem> _searchItens = [];

  _onBuscaItem(String text) async {
    print('DBG: ' + text);
    _searchItens.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _cidadeList.forEach((cidade) {
      if (cidade.nomeCidade.toLowerCase().contains(text)) {
        print('entrou: ' + text);
        _searchItens.add(cidade);
      }
      setState(() {});
    });
  }
}

class CidadeItem {
  String nomeCidade;
  var corItem;

  CidadeItem(String nome, var corItem)
      : this.nomeCidade = nome,
        this.corItem = corItem;

  void setCor(var c) {
    corItem = c;
  }

  void changeTextColor() {
//    if(corItem ==  )
  }

  Text getText() {
    return Text(nomeCidade);
  }

  Color getColor() {
    return corItem;
  }
}
