import 'package:autonos_app/bloc/ProfessionalRegisterFlowBloc.dart';
import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/ui/screens/ui_cadastro_autonomo/ListagemCidadesScreen.dart';
import 'package:autonos_app/ui/screens/ui_cadastro_autonomo/ProfessionalRegisterPaymentScreen.dart';
import 'package:autonos_app/model/Service.dart';
import 'package:autonos_app/model/Estado.dart';
import 'package:autonos_app/ui/screens/ui_cadastro_autonomo/ListagemServicosScreen.dart';
import 'package:autonos_app/ui/widget/CityChipContainer.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/widget/NextButton.dart';
import 'package:autonos_app/ui/widget/ServiceChipContainer.dart';
import 'package:autonos_app/ui/widget/ChipContainerController.dart';

class ProfessionalRegisterLocationAndServiceScreen extends StatefulWidget {

  final ProfessionalRegisterFlowBloc _bloc;

  ProfessionalRegisterLocationAndServiceScreen(
      {@required ProfessionalRegisterFlowBloc bloc }
      ) : _bloc = bloc;

  @override
  ProfessionalRegisterLocationAndServiceScreenState createState() =>
      ProfessionalRegisterLocationAndServiceScreenState();
}

class ProfessionalRegisterLocationAndServiceScreenState
    extends State<ProfessionalRegisterLocationAndServiceScreen> {

  static const String KEY_NONE = Estado.KEY_NONE;
  static const Map<String, String> DROPDOWN_MENU_OPTIONS = Estado.STATES_MAP;
  ChipContainerController _serviceChipController;
  ChipContainerController _cityChipController;
  //
  // TODO: IMPLEMENTAR BLOC PARA ESTA TELA. OS DADOS DEVEM FICAR NO MESMO.

  List<Cidade> _cidadesSelecionadas = new List();
  List<Service> _servicosSelecionados = new List();
  Estado _selectedState;
  RaisedButton _buttonListCidades;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _dropdownCurrentOption;

  final _VERTICAL_SEPARATOR = SizedBox( height: 8.0,);

  @override
  void initState() {
    _initDropdownMenu();
    super.initState();
  }

  void _initDropdownMenu() {
    _dropDownMenuItems = getDropDownMenuItems();
    _dropdownCurrentOption = _dropDownMenuItems[0].value;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> itens = new List();

    for (String estado in DROPDOWN_MENU_OPTIONS.values) {
      itens.add(new DropdownMenuItem( value: estado, child: new Text(estado)) );
    }
    return itens;
  }

  void onDropdownItemSelected(String dataSelected) {
    if ( _dropdownCurrentOption != dataSelected ) {
      setState(() {
        _cidadesSelecionadas.clear();
        _cityChipController.clear();
        _dropdownCurrentOption = dataSelected;
      });
      // TODO DEVEMOS HABILITAR E/OU DESABILITAR O BOTÃO DE SELECIONAR CIDADE DE ACORDO
      // COM A OPÇÃO SELECIONADA
    }
  }

  _gotoCityListScreen(BuildContext context) async {

    var key = DROPDOWN_MENU_OPTIONS.keys.firstWhere(
        (k) => DROPDOWN_MENU_OPTIONS[k] == _dropdownCurrentOption,
        orElse: () => null);
    print("$key $_dropdownCurrentOption selecionado");

    // SE o cara selecionou 1 estado!
    if (key.compareTo(KEY_NONE) != 0) {
      _selectedState = Estado(_dropdownCurrentOption);
      _selectedState.sigla = key;

      List<Cidade> cidadesSelecionadasAux = List.from(_cidadesSelecionadas);

      _cidadesSelecionadas = await Navigator.of(context).push(
          MaterialPageRoute( builder: (BuildContext context) => ListagemCidades(
                estado: _selectedState,
                alreadySelectedCities: _cidadesSelecionadas,
              )
          )
      );

      /*Se ele já havia ido à cityListwidget selecionou algumas cidades,
      * retornou para a atual tela, mas resolveu ir novamente na CityListWidget,
      * e não selecionou nada, mantemos o registro das cidades que já foram selecionadas
      * na primeira ida da CityListWidget.*/
      if (_cidadesSelecionadas == null) {
        print("CIDADES SELECIONADAS E NULL!! AUXILIA IS ${cidadesSelecionadasAux.length}");
        _cidadesSelecionadas = cidadesSelecionadasAux;
      } else
        print("retornou ${_cidadesSelecionadas.length} cidades");
      _cityChipController.clear();
      _cityChipController.addAll( _cidadesSelecionadas );
    }
    else {
      // EH pq ele nao selecinou estado algum!
    }
  }

  _gotoServiceListScreen(BuildContext context) async {
    List<Service> servicosSelecionadoAux = List.from(_servicosSelecionados);

    _servicosSelecionados = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ListagemServicos(
              alreadySelectedServices: _servicosSelecionados,
            )
        )
    );

    //se o usuario nao selecionou nenhum servico
    if (_servicosSelecionados == null) {
      _servicosSelecionados = servicosSelecionadoAux;
    }
    _serviceChipController.clear();
    _serviceChipController.addAll( _servicosSelecionados);
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

    final cidadeLabel = Text( 'Cidades que você atua:',
      style: TextStyle(color: Colors.grey),
      maxLines: 1,
      textAlign: TextAlign.center,
    );

    _buttonListCidades = RaisedButton(
        color: Colors.red[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text( 'Cidades ', style: TextStyle(color: Colors.white), ),
            Text( '($_dropdownCurrentOption)', style: TextStyle(color: Colors.black54),),
          ],
        ),
        onPressed: () {
          _gotoCityListScreen(context);
        });

    final cityChipContainer = CityChipContainer(
      controllerCallback: (controller) { _cityChipController = controller; },
      onDelete: ( serviceDeleted ){
        if(_cidadesSelecionadas.contains(serviceDeleted))
          _cidadesSelecionadas.remove(serviceDeleted);
      },
    );

    final areasDeAtuacaoLabel = Text( 'Areas de atuação:',
      style: TextStyle( color: Colors.grey, ),
      maxLines: 1,
      textAlign: TextAlign.center,
    );

    final buttonListServico = RaisedButton(
      child: Text( 'Serviços',
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.blueGrey,
      onPressed: () {
        _gotoServiceListScreen(context);
      },
    );

    final serviceChipContainer = ServiceChipContainer(
      onDelete: (serviceDeleted) {
        if (_servicosSelecionados.contains( serviceDeleted )){
          print("deleting ${serviceDeleted.name}");
          _servicosSelecionados.remove( serviceDeleted );
        }
      },
      controllerCallback: (controller) { _serviceChipController = controller; },
    );
//    bool a = true;
    final nextButton = NextButton(
      buttonColor: Colors.green[300],
      text: '[2/3] Próximo Passo',
//      text: a ? 'a': 'b',
      textColor: Colors.white,
      callback: () {

        _gettingInputData();

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                 ProfessionalRegisterPaymentScreen(
                   bloc: widget._bloc,
                 ),
        )
        );
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
        cityChipContainer,
        Divider(),
        _VERTICAL_SEPARATOR,
        areasDeAtuacaoLabel,
        buttonListServico,
        serviceChipContainer,
        Divider(),
        _VERTICAL_SEPARATOR,
        nextButton,
      ],
    );
  }

  //TODO tem que validar os dados!
  void _gettingInputData(){
    widget._bloc.insertLocationsAndServices(
        state: _selectedState,
        yourCities: _cidadesSelecionadas,
        yourServices: _servicosSelecionados,
        currentLocation: UserRepository().currentLocation,
        professionalName: UserRepository().currentUser.name );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Localização & Serviços',
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

}