import 'package:autonomosapp/bloc/CityListWidgetBloc.dart';
import 'package:autonomosapp/model/Cidade.dart';
import 'package:autonomosapp/model/Estado.dart';
import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/CityListWidget.dart';
import 'package:autonomosapp/ui/widget/ModalRoundedProgressBar.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUfCidadesServicosProfissionaisHelper.dart';

//TODO implementar bloc nessa tela
class LocationEditorScreen extends StatefulWidget {
  final _defaultTextStyle = TextStyle( fontSize: 19.0 );
  final _defaultUserState;
  final List<Cidade> _defaultUserCities;
  static const Map<String, String> _DROPDOWN_MENU_OPTIONS = Estado.STATES_MAP;

  LocationEditorScreen({@required String initialState, @required List<String> userCities}) :
      _defaultUserState = initialState,
      _defaultUserCities = userCities.map((city){ return Cidade(0, city, initialState); }).toList();

  @override
  _LocationEditorScreenState createState() => _LocationEditorScreenState();
}

class _LocationEditorScreenState extends State<LocationEditorScreen> {
  String _currentStateSelected;
  var _cityListWidget;
  List<String> _stateList = LocationEditorScreen._DROPDOWN_MENU_OPTIONS.keys.toList();
  List<Cidade> _selectedCityList;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  ProgressBarHandler _handler;

  @override
  void initState() {
    super.initState();
    _currentStateSelected = widget._defaultUserState;
    _selectedCityList = List.from( widget._defaultUserCities);
    _stateList.removeAt(0); // remove o KEY NONE...
    _cityListWidget = _createCityListWidget();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: .0,
            brightness: Brightness.dark,
            title: Text("Editar Locais"),
            actions: <Widget>[
              Theme(
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: _currentStateSelected,
                        items: _createItems(),
                        onChanged: _changeCityListCallback
                    ),
                  ),
                ),

                data: ThemeData.light(),

              ),
            ],
          ),

          body: _cityListWidget,

          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.done),
              tooltip: Constants.TOOLTIP_CONFIRM,
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: _saveData),
        ),
        ModalRoundedProgressBar(
          handleCallback:(handler){_handler = handler;} ,
        )
      ],
    );
  }

  List<DropdownMenuItem<String>> _createItems(){
    List<DropdownMenuItem<String>> list = List();
    for (String sigla in _stateList)
      list.add(
        DropdownMenuItem(
          child: Text(sigla, style: widget._defaultTextStyle,),
          value: sigla,
        ),
      );
    return list;
  }

  ///callback utilizada quando o usuario seleciona um novo estado da federação e uma
  ///nova lista de municipios será exibida.
  void _changeCityListCallback(String sigla){
    if (_currentStateSelected == sigla){
      print("no needs update");
      return;
    }

    setState(() {
      _currentStateSelected = sigla;
      /// se o usuario voltar a selecionar seu estado federativo já registrado,
      /// as cidadesjá escolhidas no passado voltam a ser marcadas.
      if (sigla == widget._defaultUserState)
        _selectedCityList = List.from(widget._defaultUserCities);
      else
        _selectedCityList.clear();
      _cityListWidget = _createCityListWidget();
    });
  }

  Widget _createCityListWidget(){
    return CityListWidgetBlocProvider(
      child: CityListWidget(
          sigla: _currentStateSelected,
          initialSelectedItems: _selectedCityList,
          itemsSelectedCallback: (selectedCities){
            _selectedCityList = selectedCities;
            print("TOTAL selected cities: ${_selectedCityList.length}");
          }
      ),
    );
  }

  void _saveData(){
    User user = UserRepository().currentUser;
    if (_selectedCityList.isEmpty){
      _showWarningSnackbar();
      return;
    }


    _handler.show(message:  "Atualizando dados...");
    if ( (_selectedCityList != widget._defaultUserCities) ){
      List<Cidade> _deletedCities = List();
      for(Cidade maybeRemovedCity in widget._defaultUserCities){
        if (!_selectedCityList.contains(maybeRemovedCity))
          _deletedCities.add( maybeRemovedCity );
      }

      // se o usuario removeu cidades anteriomente cadastradas
      //removemos o relacionamento do db.
      if (_deletedCities.isNotEmpty){
        user.professionalData.cidadesAtuantes =
            _deletedCities.map((city){ return city.nome;}).toList();

        List<Service> serviceList = user.professionalData
            .servicosAtuantes.map((serviceId) { return Service(serviceId,""); } ).toList();

        FirebaseUfCidadesServicosProfissionaisHelper.removeServicesFromProfessionalUser(
          user.uid, serviceList, user.professionalData);
      }

      // colocando a nova lista de cidades & estado atuante no user repository
      user.professionalData.cidadesAtuantes =
          _selectedCityList.map( (city) { return city.nome;}).toList();
      user.professionalData.estadoAtuante = _currentStateSelected;

      FirebaseUserHelper.setUserProfessionalData(
          uid: UserRepository().currentUser.uid,
          data: UserRepository().currentUser.professionalData
      );
    }

    _handler.dismiss();
    Navigator.pop(context);
  }

  void _showWarningSnackbar(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(
          "Você deve selecionar pelo menos uma cidade.",
        ),
          backgroundColor: Colors.red,
        )
    );
  }
}