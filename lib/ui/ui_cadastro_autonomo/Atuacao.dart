import 'package:autonos_app/ui/ui_cadastro_autonomo/FormasDePagamento.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ListagemCidades.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ListagemServicos.dart';
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

  var _cidadesBa = <String>[
    "Alagoinhas",
    "Amelia Rodrigues",
    "Baixios",
    "Conde",
    "Camaçarí",
    "Conceição do Jacuípe",
    "Conceição de Coité",
    "Cruz das Almas",
    "Feira de Santana",
    "Jacobina",
    "Jaguaquara"
    "Juazeiro",
    "Jequié",
    "Nova Fatima",
    "Mucuri",
    "Itabuna",
    "ictacaré",
    "Irecê",
    "Itaparica",
    "Riachão",
    "Santo Antônio de Jesus",
    "Santa Barbara",
    "Serrinha",
    "Simões Filhos",
    "Vitória da Conquista",
  ];
  var _servicos = <String>[
    "Alarmes",
    "Aulas de violão",
    "Aulas de matematica",
    "Aulas de portugues",
    "Diarista",
    "Mecanico"
  ];

  List<String> _cidadesSelcionadas = new List();
  List<String> _servicosSelecionados = new List();
  
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
      if(_estadoAtual!=estadoSelecionado){
        _cidadesSelcionadas.clear();
        _chipList.clear();
      }
      _estadoAtual = estadoSelecionado;
    });
  }
  void removeChip(String nomeChip) {
    _cidadesSelcionadas.remove(nomeChip);
    _trasnformaListaSelecionadoEmChip();
  }

  void removeServicoChip(String nomeChip) {
    _servicosSelecionados.remove(nomeChip);
    _trasnformaListaServicosSelecionadoEmChip();
  }
  void _trasnformaListaSelecionadoEmChip() {
    _chipList.clear();
    if(_cidadesSelcionadas!=null)
    for (String nomeCidade in _cidadesSelcionadas) {
      Chip chip = Chip(
        onDeleted: () {
          setState(() {
            removeChip(nomeCidade);
          });
        },
        backgroundColor: Colors.red[200],
        label: Text(
          nomeCidade,
          style: TextStyle(color: Colors.white),
        ),
      );
      setState(() {
        _chipList.add(chip);
      });
    }
  }
  void _trasnformaListaServicosSelecionadoEmChip() {
    _chipListServicos.clear();
    if(_servicosSelecionados!=null)
    for (String nomeServico in _servicosSelecionados) {
      Chip chip = Chip(
        onDeleted: () {
          setState(() {
            removeServicoChip(nomeServico);
          });
        },
        backgroundColor: Colors.blueGrey[300],
        label: Text(
          nomeServico,
          style: TextStyle(color: Colors.white),
        ),
      );
      setState(() {
        _chipListServicos.add(chip);
      });
    }
  }

  _navegarEEsperarLista(BuildContext context) async{
    List<String> cidadesSelecionadasAux = _cidadesSelcionadas;
    _cidadesSelcionadas = await Navigator.of(context).push(
        MaterialPageRoute(builder:
            (BuildContext context) => ListagemCidades(
          cidadesConfirmadas: cidadesSelecionadasAux,
          cidades: _cidadesBa,
          nome: _estadoAtual,)
        )
    );
    if(_cidadesSelcionadas == null){
      _cidadesSelcionadas = cidadesSelecionadasAux;
    }
    _trasnformaListaSelecionadoEmChip();
  }


  _navegaEEseraListaDeServicos(BuildContext context) async{
    List<String> servicosSelecionadoAux = _servicosSelecionados;
    _servicosSelecionados = await Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => ListagemServicos(
          servicosConfirmados: servicosSelecionadoAux,
          servicos: _servicos,
        ))
    );
    if(_servicosSelecionados== null){
      _servicosSelecionados = servicosSelecionadoAux;
    }
    _trasnformaListaServicosSelecionadoEmChip();
  }
  List<Widget> _buildForm(BuildContext context) {
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
        color: Colors.red[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Cidades ', style: TextStyle(color: Colors.white),),
            Text('($_estadoAtual)', style: TextStyle(color: Colors.black54),),
          ],
        ),
          onPressed: (){
            _navegarEEsperarLista(context);
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
    final buttonListServico = Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, .0),
      child:
          RaisedButton(
            child: Text('Serviços',style: TextStyle(color: Colors.white),),
            color: Colors.blueGrey,
            onPressed: () {
              _navegaEEseraListaDeServicos(context);
//              Navigator.of(context).push(
//               MaterialPageRoute(builder: (BuildContext context) =>ListagemServicos(
//                 servicos: _servicos,
//               ))
//              );
            },

          )

    );
    final listChipServico =Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(children: _chipListServicos)
    );

    final buttonNext = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(.0, 8.0, .0, 8.0),
        onPressed: (){

          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => FormaDePagamento())
          );
        },
        color: Colors.green[300],
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
            buttonListServico,
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
            style: TextStyle(color: Colors.blueGrey),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.red[300]),
        ),
        body: new Stack(
//          alignment: AlignmentDirectional(16.0, 16.0),
          children: _buildForm(context),
        ));
  }
}