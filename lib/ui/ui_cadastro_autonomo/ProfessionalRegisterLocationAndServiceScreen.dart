import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ListagemCidadesScreen.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ProfessionalRegisterPaymentScreen.dart';
import 'package:autonos_app/model/Service.dart';
import 'package:autonos_app/model/Estado.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ListagemServicosScreen.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/widget/NextButton.dart';
import 'package:autonos_app/model/ProfessionalData.dart';

class ProfessionalRegisterLocationAndServiceScreen extends StatefulWidget {
  //TODO usar o bloc de registro... GLOBAL!!
  ProfessionalData _profissionalData;

  ProfessionalRegisterLocationAndServiceScreen(
      {@required ProfessionalData data})
      : _profissionalData = data;

  @override
  ProfessionalRegisterLocationAndServiceScreenState createState() =>
      ProfessionalRegisterLocationAndServiceScreenState();
}

class ProfessionalRegisterLocationAndServiceScreenState
    extends State<ProfessionalRegisterLocationAndServiceScreen> {
  static const String KEY_NONE = "NONE";
  static const Map<String, String> DROPDOWN_MENU_OPTIONS = const {
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


  List<Cidade> _cidadesSelcionadas = new List();
  List<Service> _servicosSelecionados = new List();
  List<Chip> _chipList = [];
  List<Chip> _chipListServicos = [];

  RaisedButton _buttonListCidades;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _dropdownCurrentOption;
  final _VERTICAL_SEPARATOR = SizedBox(
    height: 8.0,
  );

  @override
  void initState() {
    _initDropdownMenu();
    print(widget._profissionalData);
    super.initState();
  }

  void _initDropdownMenu() {
    _dropDownMenuItems = getDropDownMenuItems();
    _dropdownCurrentOption = _dropDownMenuItems[0].value;
    print("dropdown current option $_dropdownCurrentOption");
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> itens = new List();

    for (String estado in DROPDOWN_MENU_OPTIONS.values) {
      itens.add(new DropdownMenuItem(value: estado, child: new Text(estado)));
    }
    return itens;
  }

  void onDropdownItemSelected(String dataSelected) {
    if (_dropdownCurrentOption != dataSelected) {
      setState(() {
        _cidadesSelcionadas.clear();
        _chipList.clear();
        _dropdownCurrentOption = dataSelected;
      });
      // TODO DEVEMOS HABILITAR E/OU DESABILITAR O BOTÃO DE SELECIONAR CIDADE DE ACORDO
      // COM A OPÇÃO SELECIONADA
    }
  }

  void removeCidadeChip(Cidade cidade) {
    _cidadesSelcionadas.remove(cidade);
    _trasnformaListaCidadeSelecionadoEmChip();
  }

  void removeServicoChip(Service service) {
    _servicosSelecionados.remove(service);
    _trasnformaListaServicosSelecionadoEmChip();
  }

// deve ir para um outro Bloc
  void _trasnformaListaCidadeSelecionadoEmChip() {
    _chipList.clear();
    if (_cidadesSelcionadas != null)
      for (Cidade city in _cidadesSelcionadas) {
        Chip chip = Chip(
          onDeleted: () {
            setState(() {
              removeCidadeChip(city);
            });
          },
          backgroundColor: Colors.red[200],
          label: Text(
            city.nome,
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
      for (Service service in _servicosSelecionados) {
        Chip chip = Chip(
          onDeleted: () {
            setState(() {
              removeServicoChip(service);
            });
          },
          backgroundColor: Colors.blueGrey[300],
          label: Text(
            service.name,
            style: TextStyle(color: Colors.white),
          ),
        );
        setState(() {
          _chipListServicos.add(chip);
        });
      }
  }

  _gotoCityListScreen(BuildContext context) async {

    var key = DROPDOWN_MENU_OPTIONS.keys.firstWhere(
        (k) => DROPDOWN_MENU_OPTIONS[k] == _dropdownCurrentOption,
        orElse: () => null);
    print("$key $_dropdownCurrentOption selecionado");

    // SE o cara selecionou 1 estado!
    if (key.compareTo(KEY_NONE) != 0) {
      Estado estadoSelecionado = Estado(_dropdownCurrentOption);
      estadoSelecionado.sigla = key;

      List<Cidade> cidadesSelecionadasAux = _cidadesSelcionadas;
      _cidadesSelcionadas = await Navigator.of(context).push(
          MaterialPageRoute( builder: (BuildContext context) => ListagemCidades(
                estado: estadoSelecionado,
                alreadySelectedCities: cidadesSelecionadasAux,
              )));

      /*Se ele já havia ido à cityListwidget selecionou algumas cidades,
      * retornou para a atual tela, mas resolveu ir novamente na CityListWidget,
      * e não selecionou nada, mantemos o registro das cidades que já foram selecionadas
      * na primeira ida da CityListWidget.*/
      if (_cidadesSelcionadas == null) {
        _cidadesSelcionadas = cidadesSelecionadasAux;
      }

      _trasnformaListaCidadeSelecionadoEmChip();
    }
    else {
      // EH pq ele nao selecinou estado algum!
    }
  }

  _gotoServiceListScreen(BuildContext context) async {
    List<Service> servicosSelecionadoAux = _servicosSelecionados;

    _servicosSelecionados = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ListagemServicos(
              alreadySelectedServices: _servicosSelecionados,
            )));
    if (_servicosSelecionados == null) {
      _servicosSelecionados = servicosSelecionadoAux;
    }
    _trasnformaListaServicosSelecionadoEmChip();
  }

  Widget _buildForm(BuildContext context) {
    final estadoLabel = Text(
      'Selecione seu estado:',
      style: TextStyle(color: Colors.grey),
    );

    final estados = Row(
      children: <Widget>[
        new DropdownButton(
            hint: Text("Selecione um estado"),
            value: _dropdownCurrentOption,
            items: getDropDownMenuItems(),
            onChanged: onDropdownItemSelected),
      ],
    );

    final cidadeLabel = Text(
      'Cidades que você atua:',
      style: TextStyle(color: Colors.grey),
      maxLines: 1,
      textAlign: TextAlign.center,
    );

    _buttonListCidades = RaisedButton(
        color: Colors.red[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cidades ',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '($_dropdownCurrentOption)',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
        onPressed: () {
          _gotoCityListScreen(context);
        });

    final listChip = Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(children: _chipList));

    final areasDeAtuacaoLabel = Text(
      'Areas de atuação:',
      style: TextStyle(
        color: Colors.grey,
      ),
      maxLines: 1,
      textAlign: TextAlign.center,
    );

    final buttonListServico = RaisedButton(
      child: Text(
        'Serviços',
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.blueGrey,
      onPressed: () {
        _gotoServiceListScreen(context);
      },
    );

    final listChipServico = Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(
          children: _chipListServicos,
        ));

    final nextButton = NextButton(
      buttonColor: Colors.green[300],
      text: '[2/3] Próximo Passo',
      textColor: Colors.white,
      callback: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ProfessionalRegisterPaymentScreen()));
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
        _buttonListCidades,
        listChip,
        Divider(),
        _VERTICAL_SEPARATOR,
        areasDeAtuacaoLabel,
        buttonListServico,
        listChipServico,
        Divider(),
        _VERTICAL_SEPARATOR,
        nextButton,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("ProfessionalRegisterLocationAndServicesScren build()");

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
        child: _buildForm(context),
      ),
    );
  }

  void _changeDropdownCurrentOption(String option){
    setState(() {
      _dropdownCurrentOption = option;
    });
  }

}
