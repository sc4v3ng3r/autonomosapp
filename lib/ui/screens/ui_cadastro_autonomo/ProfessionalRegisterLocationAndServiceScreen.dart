import 'package:autonomosapp/bloc/ProfessionalRegisterFlowBloc.dart';
import 'package:autonomosapp/model/Cidade.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/ListagemCidadesScreen.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/ProfessionalRegisterPaymentScreen.dart';
import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/model/Estado.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/ListagemServicosScreen.dart';
import 'package:autonomosapp/ui/widget/CityChipContainer.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/NextButton.dart';
import 'package:autonomosapp/ui/widget/ServiceChipContainer.dart';
import 'package:autonomosapp/ui/widget/ChipContainerController.dart';
import 'package:autonomosapp/ui/widget/StateDropDownWidget.dart';
import 'package:autonomosapp/ui/widget/EditableButton.dart';

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
  EditableButtonController _buttonController;

  //
  // TODO: IMPLEMENTAR BLOC PARA ESTA TELA. OS DADOS DEVEM FICAR NO MESMO.

  List<Cidade> _cidadesSelecionadas = new List();
  List<Service> _servicosSelecionados = new List();
  Estado _selectedState;
  String _dropdownCurrentOption;

  final _VERTICAL_SEPARATOR = SizedBox( height: 8.0,);

  @override
  void initState() {
    super.initState();
  }

  String _getStateKey(String stateName){
    var key = DROPDOWN_MENU_OPTIONS.keys.firstWhere(
            (k) => DROPDOWN_MENU_OPTIONS[k] == stateName,
        orElse: () => null);
    return key;
  }

  _gotoCityListScreen() async {
    var key = _getStateKey(_dropdownCurrentOption);
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

  _gotoServiceListScreen() async {
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

    List<String> stateList = DROPDOWN_MENU_OPTIONS.values.toList();
    final dropDownButton = Row(
      children: <Widget>[
        StateDropDownWidget(
          items: stateList,
          initialValue: stateList[0],
          title: "Selecione seu Estado",
          onItemSelected: (String item) {
            _cityChipController.clear();
            _cidadesSelecionadas.clear();
            _dropdownCurrentOption = item;
            var key = _getStateKey(item);
            if (key == KEY_NONE)
              _buttonController.changeSecondName("");
            else
              _buttonController.changeSecondName(item);
          },
        )
      ],
    );

    final cidadeLabel = Text( 'Cidades que você atua:',
      style: TextStyle(color: Colors.grey),
      maxLines: 1,
      textAlign: TextAlign.center,
    );

    final cityButton = EditableButton(
      controllerCallback: (controller) {
        _buttonController = controller;
      },
      onPressed: (){
        _gotoCityListScreen();
      },
    );

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
        _gotoServiceListScreen();
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
        dropDownButton,
        //estados,
        Divider(),
        _VERTICAL_SEPARATOR,
        cidadeLabel,
        cityButton,
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
  void
  _gettingInputData(){
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
        title: Text('Localização & Serviços',
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