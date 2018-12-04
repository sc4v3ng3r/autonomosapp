import 'package:autonos_app/ui/ui_cadastro_autonomo/FormasDePagamento.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ListagemCidades.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ListagemServicos.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/widget/NextButton.dart';

class Atuacao extends StatefulWidget {
  @override
  AtuacaoState createState() => AtuacaoState();
}

class AtuacaoState extends State<Atuacao> {
  static const String KEY_NONE = "NONE";
  static const Map<String, String> STATES = const {
    KEY_NONE: "Selecione seu Estado",
    "AC": "Acre",
    "AL": "Alagoas",
    "AM": "Amazonas",
    "AP": "Amapá",
    "BA": "Bahia",
    "CE": "Ceará",
    "DF": "Distrito Federal",
    "ES": "Espírito Santo",
    "GO": "Goiás",
    "MA": "Maranhão",
    "MG": "Minas Gerais",
    "MS": "Mato Grosso do Sul",
    "MT": "Mato Grosso",
    "PA": "Pará",
    "PB": "Paraíba",
    "PE": "Pernambuco",
    "PI": "Piauí",
    "PR": "Paraná",
    "RJ": "Rio de Janeiro",
    "RN": "Rio Grande do Norte",
    "RO": "Rondônia",
    "RR": "Roraima",
    "RS": "Rio Grande do Sul",
    "SC": "Santa Catarina",
    "SE": "Sergipe",
    "SP": "São Paulo",
    "TO": "Tocantins"
  };

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
  final _VERTICAL_SEPARATOR = SizedBox(height: 8.0,);

  @override
  void initState() {
    _dropDownMenuItem = getDropDownMenuItem();
    _estadoAtual = _dropDownMenuItem[0].value;

    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItem() {
    List<DropdownMenuItem<String>> itens = new List();

    for (String estado in STATES.values) {
      itens.add(new DropdownMenuItem(value: estado, child: new Text(estado)));
    }

    return itens;
  }

  void changeDropDownItens(String estadoSelecionado) {
    if (_estadoAtual != estadoSelecionado) {
      var key = STATES.keys.firstWhere((k) => STATES[k] == estadoSelecionado,
          orElse: () => null);
      print("$key $estadoSelecionado selecionado");
      if (key != KEY_NONE) {
        // TODO CARREGAR  lista de cidades do DB
        setState(() {
          _cidadesSelcionadas.clear();
          _chipList.clear();
          _estadoAtual = estadoSelecionado;
        });
      } else {
        //desabilita o botão de cidades
      }
    }
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
    if (_cidadesSelcionadas != null)
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
    if (_servicosSelecionados != null)
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

  // TODO O que eh isso aqui!?????!!!!!
  _navegarEEsperarLista(BuildContext context) async {
    List<String> cidadesSelecionadasAux = _cidadesSelcionadas;
    _cidadesSelcionadas = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ListagemCidades(
              cidadesConfirmadas: cidadesSelecionadasAux,
              cidades: _cidadesBa,
              nome: _estadoAtual,
            )));
    if (_cidadesSelcionadas == null) {
      _cidadesSelcionadas = cidadesSelecionadasAux;
    }
    _trasnformaListaSelecionadoEmChip();
  }

  // TODO WHAAATTT?????!!!
  _navegaEEseraListaDeServicos(BuildContext context) async {
    List<String> servicosSelecionadoAux = _servicosSelecionados;
    _servicosSelecionados = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ListagemServicos(
              servicosConfirmados: servicosSelecionadoAux,
              servicos: _servicos,
            )));
    if (_servicosSelecionados == null) {
      _servicosSelecionados = servicosSelecionadoAux;
    }
    _trasnformaListaServicosSelecionadoEmChip();
  }

  Widget _buildForm(BuildContext context) {

    final estadoLabel =Text('Selecione seu estado:', style: TextStyle(color: Colors.grey),);

    final estados = Row( children: <Widget>[
      new DropdownButton(
          value: _estadoAtual,
          items: getDropDownMenuItem(),
          onChanged: changeDropDownItens),
        ],
      );

    final cidadeLabel = Text('Cidades que você atua:',
      style: TextStyle(color: Colors.grey),
      maxLines: 1,
      textAlign: TextAlign.center,);

    final buttonListCidades = RaisedButton(
            color: Colors.red[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Cidades ',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '($_estadoAtual)',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
            onPressed: () {
              _navegarEEsperarLista(context);
            }
            );

    final listChip = Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(children: _chipList));

    final areasDeAtuacaoLabel = Text(
      'Areas de atuação:',
      style: TextStyle(color: Colors.grey,),
      maxLines: 1,
      textAlign: TextAlign.center,);

    final buttonListServico = RaisedButton(
          child: Text(
            'Serviços',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blueGrey,
          onPressed: () {
            _navegaEEseraListaDeServicos(context);
          },
        );

    final listChipServico = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child:  Wrap( children: _chipListServicos,));

    final nxButton = NextButton(
      buttonColor: Colors.green[300],
      text: '[2/3] Próximo Passo',
      textColor: Colors.white,
      callback: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => FormaDePagamento()));
      },
    );

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        estadoLabel,
        estados,
        Divider(),
        _VERTICAL_SEPARATOR,
        cidadeLabel,
        buttonListCidades,
        listChip,
        Divider(),
        _VERTICAL_SEPARATOR,
        areasDeAtuacaoLabel,
        buttonListServico,
        listChipServico,
        Divider(),
        _VERTICAL_SEPARATOR,
        nxButton,
      ],
    );
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, .0),
        child: _buildForm(context),),
    );
  }

}
// ,