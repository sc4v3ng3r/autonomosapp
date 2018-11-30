import 'package:autonos_app/ui/ui_cadastro_autonomo/FormasDePagamento.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ListagemCidades.dart';
import 'package:flutter/material.dart';

class Atuacao extends StatefulWidget {
  @override
  AtuacaoState createState() => AtuacaoState();
}

class AtuacaoState extends State<Atuacao> {

  List _estados = [
    "Acre",
    "Amapá",
    "Amazonas",
    "Bahia",
    "Brasilia",
    "Ceará",
    "Curitiba",
    "Espirito Santo",
    "Goiás",
    "Macapa",
    "Manaus",
    "Mato Grosso do Sul",
    "Minas Gerais",
    "Paraná",
    "Pernambuco",
    "Pará",
    "Rio Grande Do Norte",
    "Rio Grande Do Sul",
    "Rio de Janeiro",
    "São Pauro",
    "Santa Catarina",
    "Sergipe",
  ];

  List<String> _cidadesBa = [
    "Amelia Rodrigues",
    "Baixios",
    "Conde",
    "Conceição do Jacuípe",
    "Conceição de Coité",
    "Feira de Santana",
    "Amelia Rodrigues",
    "Baixios",
    "Conde",
    "Conceição do Jacuípe",
    "Conceição de Coité",
    "Feira de Santana",
    "Amelia Rodrigues",
    "Baixios",
    "Conde",
    "Conceição do Jacuípe",
    "Conceição de Coité",
    "Feira de Santana",
    "Amelia Rodrigues",
    "Baixios",
    "Conde",
    "Conceição do Jacuípe",
    "Conceição de Coité",
    "Feira de Santana",
    "Amelia Rodrigues",
    "Baixios",
    "Conde",
    "Conceição do Jacuípe",
    "Conceição de Coité",
    "Feira de Santana",
  ];

  List _cidadesSelcionadas = new List();
  List _servicosSelecionados = new List();

  List _cidades;
  List<Chip> _chipList = [];
  List<Chip> _chipListServicos = [];

  List<DropdownMenuItem<String>> _dropDownMenuItem;

  String _estadoAtual;

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

  void changeDropDownItens(String estadoSelecionado) {
    print("$estadoSelecionado selecionado");
    setState(() {
//      if (estadoSelecionado == "Bahia") {
//        _cidades = _cidadesBa;
//        _cidadeAtual = _cidades[0];
//      } else {
//        _cidades = _cidadesAc;
//        _cidadeAtual = _cidades[0];
//      }
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
        ],
      ),
//    ,new DropdownButton(
//          value: _estadoAtual,
//          items: getDropDownMenuItem(),
//          onChanged: changeDropDownItens),
    );

    final cidadeLabel = Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, .0),
      child: Text(
        'Cidades que você atua:',
        style: TextStyle(color: Colors.grey),
      ),
    );
    final buttonListCidades = Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, .0),
      child: RaisedButton(
        color: Colors.red[400],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Cidades ', style: TextStyle(color: Colors.white),),
            Text('($_estadoAtual)', style: TextStyle(color: Colors.black54),),
          ],
        ),
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context)
                  => ListagemCidades(cidades: _cidadesBa,nome: _estadoAtual,))
            );
          })
    );

    final listChip = Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(children: _chipList));

    final areasDeAtuacaoLabel = Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Text(
        'Areas de atuação:',
        style: TextStyle(color: Colors.grey),
      ),
    );

    final listChipServico =Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(children: _chipListServicos)
    );

    final buttonNext = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(.0, 8.0, .0, 8.0),
        onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => FormaDePagamento())
          );
        },
        color: Colors.red[400],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '[2/3] Próximo Passo',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.directions_run, color: Colors.white,),
            ),
          ],
        ),
      ),
    );
//	final proximaTela
    final form = Form(
        child: ListView(
          children: <Widget>[
            estadoLabel,
            estados,
            Divider(),
            cidadeLabel,
            buttonListCidades,
            listChip,
            Divider(),
            areasDeAtuacaoLabel,
            listChipServico,
            Divider(),
            buttonNext,
          ],
        ));
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