import 'package:autonos_app/bloc/ServiceListWidgetBloc.dart';
import 'package:autonos_app/firebase/FirebaseUfCidadesServicosProfissionaisHelper.dart';
import 'package:autonos_app/firebase/FirebaseUserHelper.dart';
import 'package:autonos_app/model/Estado.dart';
import 'package:autonos_app/model/Location.dart';
import 'package:autonos_app/model/Service.dart';
import 'package:autonos_app/ui/screens/LoginScreen.dart';
import 'package:autonos_app/ui/screens/ui_perfil_usuario/PerfilUsuarioScreen.dart';
import 'package:autonos_app/ui/screens/ui_cadastro_autonomo/ProfessionalRegisterBasicInfoScreen.dart';
import 'package:autonos_app/ui/widget/ModalRoundedProgressBar.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/widget/ServiceListWidget.dart';
import 'package:autonos_app/utility/PermissionUtiliy.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonos_app/ui/widget/UserAccountsHackedDrawerHeader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:autonos_app/utility/LocationUtility.dart';
import 'package:flutter/services.dart';
import 'package:autonos_app/ui/widget/GenericAlertDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io' show Platform;

class MainScreen extends StatefulWidget {

  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  final bool sair = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const platform =
      const MethodChannel("autonomos.com.br.jopeb.autonosapp");

  //var _perfilFragment;
  int _drawerCurrentPosition;
  String appBarName = 'Serviços';
  Color appBarColor = Colors.red[300];
  Color appBarNameColor = Colors.white;
  Color appBarIconMenuColor = Colors.white;
  double _elevation = .0;
  User _user;
  Placemark _placemark;
  ProgressBarHandler _progressBarHandler;
  UserRepository _repository;

  @override
  void dispose() {
    super.dispose();
    _progressBarHandler = null;
  }

  @override
  void initState() {
    super.initState();
    _repository = UserRepository();
    _user = _repository.currentUser;

    _initUserPosition();

    _drawerCurrentPosition = 1;
    print("Main initState");
    _scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  //TODO esse codigo pode ser executado antes da MainScreen
  // com algumas adaptacoes para obter o placemark.
  void _initUserPosition(){
    PermissionUtility.hasLocationPermission().then( (permission){
      if (permission){
        LocationUtility.getCurrentPosition( desiredAccuracy:
        LocationAccuracy.medium ).then( (position) {
          if (position != null){
            print("starting geocoding on init");

            LocationUtility.doGeoCoding(position).then((placeMarkList) {
              _placemark =placeMarkList[0];
              print("geocoding done on init");
            });

            print("Location getting LA: ${position.latitude} LO: ${position.longitude} ");
            UserRepository().currentLocation = Location(
                latitude: position.latitude,
                longitude: position.longitude);
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
      body: _getFragment( _drawerCurrentPosition ),
      );

      return Stack(
          children: <Widget>[
            scaffold,
            modal,
          ],
      );
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
        rating: 4.3,
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: (_repository.imageUrl == null) ? AssetImage("assets/usuario.png") :
        CachedNetworkImageProvider(_repository.imageUrl),
      ),
    );
    drawerOptions.add(drawerHeader);

    final optionPerfil = ListTile(
      selected: _drawerCurrentPosition == 0,
      leading: Icon(Icons.person),
      title: Text('Perfil'),
      onTap: () => _setCurrentPosition(0),
    );
    drawerOptions.add(optionPerfil);

    final optionServices = ListTile(
      selected: _drawerCurrentPosition == 1,
      leading: Icon(Icons.work),
      title: Text('Serviços'),
      onTap: () {
        _setCurrentPosition(1);
      },
    );

    drawerOptions.add(optionServices);

    final optionHistory = ListTile(
      selected: _drawerCurrentPosition == 2,
      leading: Icon(Icons.history),
      title: Text('Histórico'),
      onTap: () => _setCurrentPosition(2),
    );
    drawerOptions.add(optionHistory);

    final optionViews = ListTile(
      selected: _drawerCurrentPosition == 3,
      leading: Icon(Icons.remove_red_eye),
      title: Text('Visualizações'),
      onTap: () => _setCurrentPosition(3),
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
      child: ListView(
        padding: EdgeInsets.all(.0),
        children: drawerOptions,
      ),
    );
  }

  _logout() {
    _auth.signOut().then((_){

    });
    //TODO WORK AROUND USER REPOSITORY
    UserRepository r = new UserRepository();
    r.currentUser = null;

    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  void _changeAppBarName(int position) {
    if (position == 0) {
      appBarColor = Colors.white;
      appBarName = 'Perfil';
      appBarNameColor = Colors.blueGrey;
      appBarIconMenuColor = Colors.red[300];
      _elevation = 4.0;
    } else if (position == 1) {
      appBarColor = Colors.red[300];
      appBarName = 'Serviços';
      appBarNameColor = Colors.white;
      appBarIconMenuColor = Colors.white;
      _elevation = .0;
    } else if (position == 2) {
      appBarColor = Colors.white;
      appBarName = 'Histórico';
      _elevation = .0;
      appBarNameColor = Colors.blueGrey;
      appBarIconMenuColor = Colors.red[300];
      _elevation = 4.0;
    } else if (position == 3) {
      appBarColor = Colors.white;
      appBarName = 'Visualizações';
      _elevation = .0;
      appBarNameColor = Colors.blueGrey;
      appBarIconMenuColor = Colors.red[300];
      _elevation = 4.0;
    } else if (position == 4) {
      appBarColor = Colors.white;
      appBarName = 'Favoritos';
      _elevation = .0;
      appBarNameColor = Colors.blueGrey;
      appBarIconMenuColor = Colors.red[300];
      _elevation = 4.0;
    }
  }

  void _setCurrentPosition(int position) {
    setState(() => _changeAppBarName(position));

    if (position != _drawerCurrentPosition)
      setState(() => _drawerCurrentPosition = position);

    // coloca o drawer p/ traz??
    Navigator.of(context).pop();
  }

  Widget _getFragment(int position) {
    switch (position) {
      case 0:
        return Center(child: PerfilUsuarioScreen());

      case 1:
        return ServiceListWidgetBlocProvider(
          child: ServiceListWidget(
            itemsSelectedCallback: null,
            clickMode: ClickMode.TAP,
            singleClickCallback: (item) {
              _serviceClickedCallback(item);
              //_serviceListItemClickHandle(item);
            },
          ), //ClientChooseServicesFragment(),
        );

      case 2:
        return Center(
          child: Text("Histórico"),
        );

      case 3:
        return Center(
          child: Text("Visualizações"),
        );

      case 4:
        return Center(
          child: Text("Favoritos"),
        );

      default:
        return Center(
          child: Text("Outras Telas!"),
        );
    }
  }

  void _serviceClickedCallback(Service item) async {
    _progressBarHandler.show( message: "Buscando Profissionais");
    Location location = UserRepository().currentLocation;
    var results = false;

    if (location == null) {
      results = await _updateUserCurrentPosition();
      if (results)
        _fetchProfessionalsAndGoToMapScreen(item);
      else {
        _progressBarHandler.dismiss();
        print("Não foi possível buscar profisisonais!");
        return;
      }
    }
    else{
      _fetchProfessionalsAndGoToMapScreen(item);
    }

  }

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

  void _fetchProfessionalsAndGoToMapScreen(Service serviceItem) async {
      String sigla = Estado.keyOfState(_placemark.administrativeArea);

      FirebaseUfCidadesServicosProfissionaisHelper
          .getProfessionalsIdsFromCityAndService( estadoSigla: sigla,
              cidadeNome: _placemark.subAdministratieArea,
              serviceId: serviceItem.id).then(
              (snapshotProfIds) {
                if (snapshotProfIds.value != null) {
                  Map<String, dynamic> idsMap = Map.from(snapshotProfIds.value);
                  List<dynamic> dataList = new List();
                  FirebaseUserHelper.getProfessionalsData(
                      idsMap.keys.toList() ).then((dataMap) {
                        dataMap.forEach( (key, value) => dataList.add(value) );
                        _showAndroidNativeMapActivity(dataList);

                      });
                }

                else {
                  // EH PQ NAO HA PROFISISONAIS PARA TAL SERVICO EM TAL CIDADE!
                  //desbloquear tela
                  _progressBarHandler.dismiss();
                  _showWarningSnackbar(serviceItem.name, _placemark.subAdministratieArea);

                }
          });
  }

  void _showWarningSnackbar(String serviceName,String cityName){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Não há profissonais para $serviceName "
            "disponíveis em $cityName",
          ),
          backgroundColor: Colors.red,
        )
    );
  }

  Future<Null> _showAndroidNativeMapActivity(List<dynamic> dataMapList) async {
    try {
      var result = await platform.invokeMethod(
          'show_maps_activity', {
            "dataList": dataMapList,
            "localLat": UserRepository().currentLocation.latitude,
            "localLong":UserRepository().currentLocation.longitude,
      });
      _progressBarHandler.dismiss();
    } on PlatformException catch (e) {
      print("ERROR ${e.message} ${e.code}");
    }
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

  /**
  *Esse MÉTODO SERÁ RESPONSÁVEL POR RECEBER AS CHAMADAS DO LADO
   * ANDROID NATIVO PARA O FLUTTER.*/
  //metodo que trata as chamadas do nativo ao flutter

  /*Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "message":
        debugPrint(call.arguments);
        return new Future.value("");
    }
  }*/

} // end of class
