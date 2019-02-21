import 'package:autonomosapp/bloc/ProfessionalRegisterFlowBloc.dart';
import 'package:autonomosapp/model/Cidade.dart';
import 'package:autonomosapp/model/Location.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/ListagemCidadesScreen.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/ProfessionalRegisterPaymentScreen.dart';
import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/model/Estado.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/ListagemServicosScreen.dart';
import 'package:autonomosapp/ui/widget/CityChipContainer.dart';
import 'package:autonomosapp/ui/widget/GenericInfoWidget.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/LocationUtility.dart';
import 'package:autonomosapp/utility/PermissionUtiliy.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/NextButton.dart';
import 'package:autonomosapp/ui/widget/ServiceChipContainer.dart';
import 'package:autonomosapp/ui/widget/ChipContainerController.dart';
import 'package:autonomosapp/ui/widget/StateDropDownWidget.dart';
import 'package:autonomosapp/ui/widget/EditableButton.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;

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
  Placemark _placemark;
  List<String> _stateList = DROPDOWN_MENU_OPTIONS.values.toList();

  @override
  void initState() {
    super.initState();
    _stateList.removeAt(0);
  }

  String _getStateKey(String stateName){
    var key = DROPDOWN_MENU_OPTIONS.keys.firstWhere(
            (k) => DROPDOWN_MENU_OPTIONS[k] == stateName,
        orElse: () => null);
    return key;
  }

  _gotoCityListScreen() async {
    var key = _getStateKey(_dropdownCurrentOption);

    print("SIGLA: $key ESTADO: $_dropdownCurrentOption selecionado");
    // SEMPRE VAI EXISTIR UM ESTADO SELECIONADO!
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
      }
      else{
        print("retornou ${_cidadesSelecionadas.length} cidades");
        _cityChipController.clear();
        _cityChipController.addAll( _cidadesSelecionadas );
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
    else {
      _serviceChipController.clear();
      _serviceChipController.addAll( _servicosSelecionados);
    }

  }

  Widget _buildLayout(BuildContext context) {

    final estadoLabel = Center(
      child: Text( 'Estado em que trabalho:',
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
    );

    final dropDownButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StateDropDownWidget(
          items: _stateList,
          initialValue: _dropdownCurrentOption,
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
      style: TextStyle(color: Theme.of(context).accentColor),
      maxLines: 1,
      textAlign: TextAlign.center,
    );

    final cityButton = EditableButton(
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Theme.of(context).accentColor,
      primaryText: "Selecionar Cidades em",
      secondaryText: "$_dropdownCurrentOption",
      controllerCallback: (controller) {
        _buttonController = controller;
      },
      onPressed: (){
        _gotoCityListScreen();
      },
    );

    final cityChipContainer = CityChipContainer(
      textColor: Theme.of(context).accentColor,
      backgroundColor: Theme.of(context).primaryColor,
      deleteButtonColor: Theme.of(context).accentColor,
      controllerCallback: (controller) { _cityChipController = controller; },
      onDelete: ( serviceDeleted ){
        if(_cidadesSelecionadas.contains(serviceDeleted))
          _cidadesSelecionadas.remove(serviceDeleted);
      },
    );

    final areasDeAtuacaoLabel = Text( 'Selecione os Serviços',
      style: TextStyle( color: Theme.of(context).accentColor, ),
      maxLines: 1,
      textAlign: TextAlign.center,
    );

    final buttonListServico = Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: RaisedButton(
              child: Text(' Meus serviços',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                _gotoServiceListScreen();
              },
            ),
        ),
      ],
    );

    final serviceChipContainer = ServiceChipContainer(
      textColor: Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).accentColor,
      deleteButtonColor: Theme.of(context).primaryColor,

      onDelete: (serviceDeleted) {
        if (_servicosSelecionados.contains( serviceDeleted )){
          print("deleting ${serviceDeleted.name}");
          _servicosSelecionados.remove( serviceDeleted );
        }
      },
      controllerCallback: (controller) { _serviceChipController = controller; },
    );

    final nextButton = NextButton(
      buttonColor: Colors.green,
      text: '[2/3] Próximo Passo',
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

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Constants.VERTICAL_SEPARATOR_16,
        estadoLabel,
        dropDownButton,
        Divider(),
        Constants.VERTICAL_SEPARATOR_8,
        cidadeLabel,
        cityButton,
        cityChipContainer,
        Divider(),
        Constants.VERTICAL_SEPARATOR_8,
        areasDeAtuacaoLabel,
        buttonListServico,
        serviceChipContainer,
        Divider(),
        Constants.VERTICAL_SEPARATOR_8,
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
        title: Text('Localização & Serviços',),
        brightness: Brightness.dark,
      ),
      body: (_placemark == null) ? FutureBuilder<bool>(
          future: _getUserCurrentPosition(context),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
            print("Current state ${snapshot.connectionState}");
            switch(snapshot.connectionState){

              case ConnectionState.none:
                return GenericInfoWidget(
                  title: "Falha ao obter localização",
                  titleColor: Colors.black,
                  subtitle: "É necessário sua localização para continuar o cadastro.",
                  icon: Icons.location_off,
                  iconColor: Theme.of(context).errorColor,
                );

              case ConnectionState.active:
              case ConnectionState.waiting:
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Constants.VERTICAL_SEPARATOR_8,
                    Center(
                      child: Text("Obtendo sua Localização..."),
                    ),
                  ],
                );

              case ConnectionState.done:
                if (snapshot.hasData){
                  if (snapshot.data){
                    _dropdownCurrentOption = _placemark.administrativeArea;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, .0),
                      child: _buildLayout(context),
                    );
                  }
                }

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: GenericInfoWidget(
                        title: "Falha ao obter localização",
                        titleColor: Colors.black,
                        subtitle: "É necessário sua localização para continuar o cadastro.",
                        icon: Icons.location_off,
                        iconColor: Theme.of(context).errorColor,
                        actionButton: true,
                        actionButtonBackground: Theme.of(context).primaryColor,
                        actionIcon: Icons.refresh,
                        actionIconColor: Theme.of(context).accentColor,
                        actionTitle: "Tentar novamente",
                        actionTitleColor: Theme.of(context).accentColor,
                        actionCallback: (){ setState(() {});},
                      ),
                    ),
                  ],
                );
                break;
            }
          }

      ) : Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, .0),
            child: SingleChildScrollView( child: _buildLayout(context),),
          ),
    );
  }

  Future<bool> _getUserCurrentPosition(final BuildContext context) async {

    if (Platform.isAndroid){
      var permission = await PermissionUtility.handleLocationPermissionForAndroid(context);
      print("permission is $permission");

      if (permission){
        Position position;
        try{
          position = await LocationUtility.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium );
          print("position is: $position");

        }
        catch(ex){
          print("_updateUserCurrentPosition $ex");
          return false;
        }

        if (position != null){
          print("geocoding");
          List<Placemark> placeMarks;
          try{
            placeMarks = await LocationUtility.doGeoCoding( position );
            _placemark = placeMarks[0];
            var location = Location(
                latitude: position.latitude,
                longitude: position.longitude);
            UserRepository.instance.currentLocation = location;

            return true;
          }

          catch (ex){
            print("_updateUserCurrentPosition error geocoding... $ex");
            return false;
          }

        }
        else {
          print("GPS deligado?:");
          return false;
        }
      }

      return false;
    }

    else {
      //TODO iOS implementation
      return false;
    }
  }
}