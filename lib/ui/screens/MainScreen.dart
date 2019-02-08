import 'dart:async';

import 'package:autonomosapp/bloc/ServiceListWidgetBloc.dart';
import 'package:autonomosapp/firebase/FirebaseUfCidadesServicosProfissionaisHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/model/Estado.dart';
import 'package:autonomosapp/model/Location.dart';
import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/ui/screens/LoginScreen.dart';
import 'package:autonomosapp/ui/screens/ProfessionalsMapScreen.dart';
import 'package:autonomosapp/ui/screens/UsersViewWidget.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/ProfessionalRegisterBasicInfoScreen.dart';
import 'package:autonomosapp/ui/widget/ModalRoundedProgressBar.dart';
import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/ServiceListWidget.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/PermissionUtiliy.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonomosapp/ui/widget/UserAccountsHackedDrawerHeader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:autonomosapp/utility/LocationUtility.dart';
import 'package:autonomosapp/ui/widget/GenericAlertDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:autonomosapp/ui/widget/PerfilDetailsWidget.dart';
import 'dart:io' show Platform;

//FIXME BUG build method é sempre chamado até mesmo quando clicamos Ok no teclado
// somente quando a MainScreen vem após a LoginScreen. Quando a aplicação já abre diretamente
// na tela de login esse bug não se manifesta e eu não sei a razão. Isso é ruim porque toda vez
// que isso acontece os wigets que atuam como fragments, por exemplo, ServiceListWidget são recriados
// e isso causa uma terrível experiencia ao usuário a exemplo quando o usuário está filtrando
// os serviços utilizando a barra de pesquisa ao pressionar OK no teclado virtual a tela é reconstruida
// e a busca é perdida pois o ServiceListWidget mostra uma nova lista.
//O armengue temporário foi segurar o ServiceListWidget como membro da classe para que quado a tela
//for redesenhada o mesmo ainda estar instanciado. Entretando é necessário anular o mesmo quando um novo
// widget toma seu lugar e criar um novo ServiceListWidget quando for necessário mostrar-lo. Isso é
//necessário para evitar problemas internos no ServiceListWidget e suas Streams.


enum  DrawerOption { PERFIL, SERVICES, VIEWS, AUTONOMOS, EXIT, DELETE_ACCOUNT }
//TODO transformar essa tela em stateless
class MainScreen extends StatefulWidget {

  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  GlobalKey _drawerKey = GlobalKey();

  final bool sair = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*static const _platform =
      const MethodChannel("autonomos.com.br.jopeb.autonosapp");*/

  DrawerOption _drawerCurrentOption;
  String appBarName = 'Serviços';
  Color appBarColor = Colors.red[300];
  Color appBarNameColor = Colors.white;
  Color appBarIconMenuColor = Colors.white;
  double _elevation = .0;
  User _user;

  Placemark _placemark;

  ProgressBarHandler _progressBarHandler;
  UserRepository _repository;
  var _serviceListFragment;

  @override
  void dispose() {
    super.dispose();
    print("MainScreenWidget dispose()");
    _progressBarHandler = null;
    _serviceListFragment = null;
  }

  @override
  void initState() {
    super.initState();
   // _platform.setMethodCallHandler( _handleMethod );
    _repository = UserRepository();
    _user = _repository.currentUser;

    _drawerCurrentOption = DrawerOption.SERVICES;
    _initUserPosition();
    _initServicesListFragment();
    print("Main initState");
    _scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  _initServicesListFragment(){
    _serviceListFragment = ServiceListWidgetBlocProvider(
      child: ServiceListWidget(
        itemsSelectedCallback: null,
        clickMode: ClickMode.TAP,
        singleClickCallback: (item) {
          _serviceClickedCallback(item);
        },
      ), //ClientChooseServicesFragment(),
    );
  }

  //TODO esse codigo pode ser executado antes da MainScreen
  // com algumas adaptacoes para obter o placemark.
  void _initUserPosition(){
    PermissionUtility.hasLocationPermission().then( (permission){
      if (permission){
        LocationUtility.getCurrentPosition( desiredAccuracy:
        LocationAccuracy.lowest ).then( (position) {
          if (position != null){
            print("starting geocoding on init");

            print("Location getting LA: ${position.latitude} LO: ${position.longitude} ");
            UserRepository().currentLocation = Location(
                latitude: position.latitude,
                longitude: position.longitude);

            LocationUtility.doGeoCoding(position).then((placeMarkList) {
              _placemark = placeMarkList[0];
              print("geocoding done on init");
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var modal = ModalRoundedProgressBar(
        handleCallback: (handler){
          _progressBarHandler = handler;
        });

    var scaffold= Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          icon: Icon(Icons.menu,color: appBarIconMenuColor,),
        ),

        title: Text(appBarName, style: TextStyle(color: appBarNameColor),),
        automaticallyImplyLeading: false,
        backgroundColor: appBarColor,
        elevation: _elevation,
      ),

      drawer: _drawerMenuBuild(context),
      body: _getFragment( _drawerCurrentOption ),
      );

      return WillPopScope(
          onWillPop: _onWillPop,
          child: Stack(
            children: <Widget>[
              scaffold,
              modal,
            ],
          ),
      );
  }

  Future<bool> _onWillPop() async {
    print("on will pop callback");
    if (drawerIsOpen()){
      return true;
    }

    if (_drawerCurrentOption == DrawerOption.SERVICES)
      return true;

    _setCurrentPosition(DrawerOption.SERVICES);
    return false;
  }

  void _NavegaCadastroAutonomo(BuildContext context) {
    Navigator.pop(context);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => ProfessionalRegisterBasicInfoScreen(),
    ));
  }

  Drawer _drawerMenuBuild(BuildContext context) {
    List<Widget> drawerOptions = List();

    print("drawer menu build");
    final drawerHeader = UserAccountsHackedDrawerHeader(
      accountEmail: Text('${_user.email}'),
      accountName: Text('${_user.name}'),
      ratingBar: RatingBar(
        starCount: 5,
        rating: _user.rating,
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: (_repository.currentUser.picturePath == null) ?
        AssetImage("assets/usuario.png") :
        CachedNetworkImageProvider(_repository.currentUser.picturePath ),
      ),
    );
    drawerOptions.add(drawerHeader);

    final optionPerfil = ListTile(
      selected: _drawerCurrentOption == DrawerOption.PERFIL,
      leading: Icon(Icons.person),
      title: Text('Perfil'),
      onTap: () => _setCurrentPosition(DrawerOption.PERFIL),
    );
    drawerOptions.add(optionPerfil);

    final optionServices = ListTile(
      selected: _drawerCurrentOption == DrawerOption.SERVICES,
      leading: Icon(Icons.work),
      title: Text('Serviços'),
      onTap: () {
        _setCurrentPosition(DrawerOption.SERVICES);
      },
    );

    drawerOptions.add(optionServices);

    /*
    final optionHistory = ListTile(
      selected: _drawerCurrentOption == 2,
      leading: Icon(Icons.history),
      title: Text('Histórico'),
      onTap: () => _setCurrentPosition(2),
    );
    drawerOptions.add(optionHistory);
     */

    final optionViews = ListTile(
      selected: _drawerCurrentOption == DrawerOption.VIEWS,
      leading: Icon(Icons.remove_red_eye),
      title: Text('Visualizações'),
      onTap: () => _setCurrentPosition(DrawerOption.VIEWS),
    );
    drawerOptions.add(optionViews);

    /*final optionFavorites = ListTile(
      leading: Icon(Icons.favorite),
      title: Text('Favoritos'),
      onTap: () => _setCurrentPosition(4),
    );
    drawerOptions.add(optionFavorites);
    */
    if (_user.professionalData == null) {
      print("MainScreen User is not a professional!!!");
      final optionRegister = ListTile(
        leading: Icon(
          Icons.directions_walk,
          color: Colors.red[500],
        ),
        title: Text('Seja Um Autônomo!!!',
            style:
                TextStyle(color: Colors.red[500], fontWeight: FontWeight.bold)),
        onTap: () => _NavegaCadastroAutonomo(context),
      );
      drawerOptions.add(optionRegister);
    }

    drawerOptions.add(Divider());
    final optionLogout = ListTile(
      leading: Icon(Icons.navigate_before),
      title: Text('Sair'),
      onTap: () {
        _logout();
      },
    );
    drawerOptions.add(optionLogout);

    final removeAccount = ListTile(
      leading: Icon(Icons.delete),
      title: Text("Remover conta"),

      onTap: () async {
        var response = await showDialog(context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return GenericAlertDialog(
              title: "Remover Conta",
              content: Text("Deseja remover sua conta?"),
              positiveButtonContent: Text("Sim"),
              negativeButtonContent: Text("Não"),
            );
          });

        if (response){
          _progressBarHandler.show(message: "Removendo dados...");
          FirebaseUserHelper.removeUser( _user ).then(
              (status){
                print("on reauth status $status");
                if (status){
                  _progressBarHandler.dismiss();
                  _logout();
                }
              });
          //_logout();
        }
      },
    );

    drawerOptions.add( removeAccount);

    return new Drawer(
      key: _drawerKey,
      child: ListView(
        padding: EdgeInsets.all(.0),
        children: drawerOptions,
      ),
    );
  }

  _logout() {
    _auth.signOut().then((_){
      //TODO WORK AROUND USER REPOSITORY
      UserRepository r = new UserRepository();
      r.currentUser = null;

      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
              (Route<dynamic> route) => false);
    });
  }

  void _changeAppBarName(DrawerOption option) {
    switch(option){
      case DrawerOption.PERFIL:
        appBarColor = Colors.white;
        appBarName = 'Perfil';
        appBarNameColor = Colors.blueGrey;
        appBarIconMenuColor = Colors.red[300];
        _elevation = 4.0;
        break;

      case DrawerOption.SERVICES:
        appBarColor = Colors.red[300];
        appBarName = 'Serviços';
        appBarNameColor = Colors.white;
        appBarIconMenuColor = Colors.white;
        _elevation = .0;
        break;

      ///case DrawerOption.HISTORY:
      ///  break;
      case DrawerOption.VIEWS:
        appBarColor = Colors.white;
        appBarName = 'Visualizações';
        _elevation = .0;
        appBarNameColor = Colors.blueGrey;
        appBarIconMenuColor = Colors.red[300];
        _elevation = 4.0;
        break;

      default:
        break;
    }
  }

  void _setCurrentPosition(DrawerOption option) {

    if (option != _drawerCurrentOption){
      setState(() {
        if (_serviceListFragment == null)
          _initServicesListFragment();

        _changeAppBarName(option);
        _drawerCurrentOption = option;
      });
    }

    if (drawerIsOpen())
      Navigator.of(context).pop();
  }

  bool drawerIsOpen(){
    final RenderBox box = _drawerKey.currentContext?.findRenderObject();
    return (box != null) ? true : false;
  }

  Widget _getFragment(DrawerOption option) {
    switch (option) {
      case  DrawerOption.PERFIL:
        _serviceListFragment = null;
        return PerfilDetailsWidget(
            user: _user
        );

      case DrawerOption.SERVICES:
        return _serviceListFragment;

        /*
      case : TODO historico em breve
        _serviceListFragment = null;
        return Center(
          child: Text("Histórico vai sair"),
        );*/

      case DrawerOption.VIEWS:
        _serviceListFragment = null;
        return UsersViewWidget();
      /*
      case 4: // TODO Breve
        _serviceListFragment = null;
        return Center(
          child: Text("Favoritos"),
        );*/
      //NUNCA DEVE VIM AQUI!!
      default:
        break;
    }
  }

  void _serviceClickedCallback(Service item) async {

    _progressBarHandler.show( message: "Buscando Profissionais");
    Location location = UserRepository().currentLocation;
    var results = false;

    if (location == null) {
      results = await _updateUserCurrentPosition();
      if (!results) {
        _progressBarHandler.dismiss();
        return;
      }
    }

    _fetchProfessionalsAndGoToMapScreen(item);

  }

  /// faz ua nova consulta à localização do usuário
  /// e atualiza sua posição no repository

  Future<bool> _updateUserCurrentPosition() async {

    if (Platform.isAndroid){
      var permission = await _handleLocationPermissionForAndroid();

      if (permission){
        Position position = await LocationUtility.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium );
        if (position != null){
          var placeMarks = await LocationUtility.doGeoCoding( position );
          _placemark = placeMarks[0];
          var location = Location(
              latitude: position.latitude,
              longitude: position.longitude);
          UserRepository().currentLocation = location;
          return true;
        }

        else {
          //GPS provavelmente desligado!
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


  void _fetchProfessionalsAndGoToMapScreen(Service serviceItem)  async {
    String sigla = Estado.keyOfState(_placemark.administrativeArea);
      FirebaseUfCidadesServicosProfissionaisHelper
          .getProfessionalsIdsFromCityAndService( estadoSigla: sigla,
          cidadeNome: _placemark.subAdministratieArea,
          serviceId: serviceItem.id).then(
              (snapshotProfIds) {
            if (snapshotProfIds.value != null) {

              Map<String, dynamic> idsMap = Map.from(snapshotProfIds.value);
              //removo usuario atual da lista caso o mesmo exerca o servico procurado
              //idsMap.remove(_user.uid);

              List<User> professionalUsersList = new List();

              FirebaseUserHelper.getProfessionalUsers(
                  idsMap.keys.toList() ).then(
                      (professionalUsersMap) {
                    professionalUsersMap.forEach( (key, value) => professionalUsersList.add(
                        User.fromJson( Map.from(value)) )
                    );

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context){
                          return ProfessionalsMapScreen(
                            screenTitle: serviceItem.name,
                            initialLatitude: _repository.currentLocation.latitude,
                            initialLongitude: _repository.currentLocation.longitude,
                            professionalList: professionalUsersList,

                          );
                        })
                    ).then((_) => _progressBarHandler.dismiss()  );
                    //_showAndroidNativeMapActivity(dataList);
                  });
            }

            else {
              // EH PQ NAO HA PROFISISONAIS PARA TAL SERVICO EM TAL CIDADE!
              //desbloquear tela
              _progressBarHandler.dismiss();
              _showWarningSnackbar(serviceItem.name, _placemark.subAdministratieArea);

            }
          }).timeout(Duration(seconds: Constants.NETWORK_TIMEOUT_SECONDS ),
              onTimeout: () => throw TimeoutException("network exception"))
          .catchError((ex){
            print(ex);
            _progressBarHandler.dismiss();
            _scaffoldKey.currentState.showSnackBar(

              SnackBar(content: Text("Não foi possível localizar profissionais. Verifique sua "
                  "conexão com a internet"),
                backgroundColor: Colors.red,
              ),
            );
          });
  }

  void _showWarningSnackbar(String serviceName,String cityName){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Não há profissonais para $serviceName"
            " disponíveis em $cityName",
          ),
          backgroundColor: Colors.red,
        )
    );
  }

  Future<Null> _showAndroidNativeMapActivity(List<dynamic> dataMapList) async {
    print("OPEN MAPS WIDGE!!!");
  }


  Future<bool> _handleLocationPermissionForAndroid() async {
    var hasPermission =  await PermissionUtility.hasLocationPermission();

    if (!hasPermission){

      var shouldShowDialog = await PermissionUtility.shouldShowReasonableDialog();
      if (shouldShowDialog){ // devemos exibir uma razao?
        var shouldShowReasonResults = await _showLocationPermissionReasonDialog();
        if (shouldShowReasonResults)
          return await PermissionUtility.requestAndroidLocationPermission();
        //usuario nao concorda com as razoes para conceder a permissao
        return false;
      }

      else {
        // nao devemos exibir uma razao...
        // else never ask again was marked
        //necessario dar as permissoes na tela de configurações do OS
        print("Never ask again marked, user must give a permition in application settings");
        var goToSettings = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context){
              return GenericAlertDialog(
                title: "Permissões",
                positiveButtonContent: Text("Ir para configurações"),
                negativeButtonContent: Text("Cancelar"),
                content: Column(
                  children: <Widget>[
                    Text("Você precisa conceder a permissão de localização "
                        "nas configurações do seu dispositivo."),
                    Text("Deseja ir a tela de configurações?"),
                  ],
                ),

              );
            }
        );
        if (goToSettings!= null && goToSettings)
          await PermissionUtility.openPermissionSettings();
        return false;
      }
    } // end of if(!hasPermission)

    // realizar a operacao!!!
    else {
      print("JA tem permissao para realizar operação");
      return true;
    }
  }

  /// Exibe dialog de razão para usuário conceder premissão de localização
  Future<bool> _showLocationPermissionReasonDialog() async {
    return await showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return GenericAlertDialog(
            title: "Permissão de Localização",
            content: Text("Autônomos precisa acessar a localização do dispositivo"),
            positiveButtonContent: Text("Conceder Permissão"),
            negativeButtonContent: Text("Cancelar"),
          );
        }
    );
  }


/**
  *Esse MÉTODO SERÁ RESPONSÁVEL POR RECEBER AS CHAMADAS DO LADO
   * ANDROID NATIVO PARA O FLUTTER.*/
  //metodo que trata as chamadas do nativo ao flutter


  /*Future<dynamic> _handleMethod(MethodCall call) async {
    print("handle_method flutter side");
    switch (call.method) {
      case "message":
        ProfessionalData data = ProfessionalData.fromJson( Map.from( call.arguments));
        return Navigator.push(context, MaterialPageRoute( builder: (builContext){
          return ProfessionalPerfilScreen(
            userProData: data,
          );
        } ) );
        //print(call.arguments);
        //return new Future.value("");
    }
  }*/

} // end of class
