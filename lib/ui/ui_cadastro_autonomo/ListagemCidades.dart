import 'package:flutter/material.dart';

class ListagemCidades extends StatefulWidget {
  final List<String> _cidadesConfirmadas;
  final String _nomeEstado;
  final List<String> _cidades;

  ListagemCidades(
      {List cidadesConfirmadas, String nome, @required List cidades})
      : this._cidadesConfirmadas = cidadesConfirmadas,
        this._nomeEstado = nome,
        this._cidades = cidades;

  @override
  ListagemCidadesState createState() =>
      ListagemCidadesState(_cidadesConfirmadas, _nomeEstado, _cidades);
}

class ListagemCidadesState extends State<ListagemCidades> {
  final List<String> _cidadesConfirmadas;
  final String _nomeEstado;
  final List<String> _cidades;

  ListagemCidadesState(
      List cidadesConfirmadas, String nomeEstado, @required List cidades)
      : this._cidadesConfirmadas = cidadesConfirmadas,
        this._nomeEstado = nomeEstado,
        this._cidades = cidades;
  TextEditingController controller = new TextEditingController();

  var colorCard;
  List<CidadeItem> _cidadeList = new List();
  List<String> _cidadesSelecionadas = new List();

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
  }

  @override
  void initState() {
    _criaListaCidade();
    super.initState();
  }

  Widget _confirmButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        SnackBar(content: Text('abc'));
//        print(_cidadesSelecionadas.length);
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
    return Scaffold(
      appBar: AppBar(
//        leading:_iconButton(context),
        actions: <Widget>[
          _confirmButton(context),
//          Icon(Icons.done,color: Colors.green[200],),
        ],
        elevation: 0.0,
        backgroundColor: Colors.red[400],
        title: Text(
          '$_nomeEstado',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(_cidadesSelecionadas);
        },
        foregroundColor: Colors.red,
        elevation: 8.0,
        backgroundColor: Colors.teal,
        child: Icon(
          Icons.add,
          color: Colors.white,
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
                    )),
              )
            ],
          )),
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
