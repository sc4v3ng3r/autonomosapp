import 'package:flutter/material.dart';

class ListagemServicos extends StatefulWidget {
  final List<String> _servicosConfirmados;
  final List<String> _servicos;

  ListagemServicos({List servicosConfirmados ,@required List servicos})
      :this._servicosConfirmados = servicosConfirmados,
        this._servicos = servicos;

  @override
  ListagemServicosState createState() =>
      ListagemServicosState( _servicosConfirmados,_servicos);
}

class ListagemServicosState extends State<ListagemServicos> {
  final List<String> _servicosConfirmados;
  final List<String> _servicos;

  ListagemServicosState(List servicosConfirmados ,@required List servicos)
      : this._servicosConfirmados = servicosConfirmados,
        this._servicos = servicos;
  TextEditingController controller = new TextEditingController();

  var colorCard;
  List<ServicoItem> _servicoList = new List();
  List<String> _servicosSelecionados = new List();
//  CidadeItem cidadeItem;

  void _criaListaServicos(){
    ServicoItem c;
    for(String nomeServico in _servicos){
      if (_servicosConfirmados != null) {
        if (_servicosConfirmados.contains(nomeServico)) {
          c = new ServicoItem(nomeServico, Colors.green[200]);
          _servicosSelecionados.add(nomeServico);
        } else
          c = new ServicoItem(nomeServico, Colors.white);
      } else
        c = new ServicoItem(nomeServico, Colors.white);
      _servicoList.add(c);
    }
  }
  @override
  void initState() {
    _criaListaServicos();
    super.initState();
  }

  Widget _confirmButton(BuildContext context){
    return IconButton(
      onPressed: (){
        SnackBar(content: Text('abc'));
//        print(_cidadesSelecionadas.length);
        Navigator.of(context).pop(_servicosSelecionados);
      },
      icon: Icon(Icons.add,color: Colors.green[200],),
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
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Serviços',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
      Navigator.of(context).pop(_servicosSelecionados);
    },
    foregroundColor: Colors.red,
    elevation: 8.0,
    backgroundColor: Colors.teal,
    child: Icon(Icons.add,color: Colors.white,),
    ),
      body: Column(
        children: <Widget>[
          new Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                        color: Colors.blueGrey,
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
                                keyboardType: TextInputType.text,
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
          new Expanded(child: _searchItens.length !=0 || controller.text.isNotEmpty
          ? new ListView.builder(
            itemCount: _searchItens.length,
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              return new Card(
                color: _searchItens[index].corItem,
                child: new ListTile(
                  onTap: (){
                    setState(() {
                      if(_searchItens[index].corItem == Colors.white){
                        _searchItens[index].setCor(Colors.green[200]);
                        _servicosSelecionados.add(_searchItens[index].nomeServico);
                      }
                      else{
                        _searchItens[index].setCor(Colors.white);
                        _servicosSelecionados.remove(_searchItens[index].nomeServico);
                      }
                    });

                  },
                  title: Text('${_searchItens[index].nomeServico}'),
                ),
              );
            },
          ):new ListView.builder(
            itemCount: _servicoList.length,
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              return new Card(
                color: _servicoList[index].corItem,
                child: new ListTile(
                  onTap: (){
                    setState(() {
                      if(_servicoList[index].corItem == Colors.white){
                        _servicoList[index].setCor(Colors.green[200]);
                        _servicosSelecionados.add(_servicoList[index].nomeServico);
                      }
                      else{
                        _servicoList[index].setCor(Colors.white);
                        _servicosSelecionados.remove(_servicoList[index].nomeServico);
                      }
                    });

                  },
                  title: Text('${_servicoList[index].nomeServico}'),
                ),
              );
            },
          )
          ),
        ],
//
      ),
    );
  }
  List<ServicoItem> _searchItens = [];

  _onBuscaItem(String text) async{
    print('DBG: '+ text);
    _searchItens.clear();
    if(text.isEmpty){
      setState(() {
      });
      return;
    }
    _servicoList.forEach((servico){
      if(servico.nomeServico.toLowerCase().contains(text)){
        print('entrou: '+ text);
        _searchItens.add(servico);
      }
      setState(() {

      });
    });

  }
}

class ServicoItem{
  String nomeServico;
  var corItem;

  ServicoItem(String nome, var corItem):
        this.nomeServico = nome,
        this.corItem = corItem;

  void setCor(var c){
    corItem = c;
  }

  void changeTextColor(){
//    if(corItem ==  )
  }

  Text getText(){
    return Text(nomeServico);
  }

  Color getColor(){
    return corItem;
  }
}
