import 'package:flutter/material.dart';

class PerfilDetalhe extends StatefulWidget {
  @override
  PerfilDetalheState createState() => PerfilDetalheState();
}

class PerfilDetalheState extends State<PerfilDetalhe> {
  static final SizedBox _verticalSeparator = new SizedBox(
    height: 16.0,
  );
  List _estados = [
    "Acre",
    "Amapá",
    "Amazonas",
    "Bahia",
    "Mato Grosso",
    "Minas Gerais",
    "Rio Grande Do Norte"
  ];

  List _cidadesBa = [
    "Amelia Rodrigues",
    "Baixios",
    "Conde",
    "Conceição do Jacuípe",
    "Conceição de Coité",
    "Feira de Santana",

  ];

  List<DropdownMenuItem<String>> _dropDownMenuItem;
  List<DropdownMenuItem<String>> _dropDownMenuItemCidades;
  String _estadoAtual;
  String _cidadeAtual;

  @override
  void initState() {
    _dropDownMenuItem = getDropDownMenuItem();
    _estadoAtual = _dropDownMenuItem[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItem() {
    List<DropdownMenuItem<String>> itens = new List();

    for (String estado in _estados) {
      itens.add(new DropdownMenuItem(value: estado, child: new Text(estado)));
    }

    return itens;

  }

  void changeDropDownItens(String estadoSelecionado){
    print("$estadoSelecionado selecionado");
    setState(() {
      _estadoAtual = estadoSelecionado;
    });
  }

  List<Widget> _buildForm() {
    final estadoLabel = Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, .0),
      child: Text(
        'Selecione seu estado:',
        style: TextStyle(color: Colors.grey),
      ),
    );
//  Text('Insira o estado que você mora:');

    final estados = Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
      child: Row(
      children: <Widget>[
      new DropdownButton(
          value: _estadoAtual,
          items: getDropDownMenuItem(),
          onChanged: changeDropDownItens),
    ],),
//    ,new DropdownButton(
//          value: _estadoAtual,
//          items: getDropDownMenuItem(),
//          onChanged: changeDropDownItens),
    );

    final form = Form(
      child: ListView(
        children: <Widget>[
          estadoLabel,
          estados
        ],
      )
    );
    var list = new List<Widget>();
    list.add(form);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Atuação',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.red[400]),
        ),
        body: new Stack(
//          alignment: AlignmentDirectional(16.0, 16.0),
          children: _buildForm(),
        ));
  }
}
