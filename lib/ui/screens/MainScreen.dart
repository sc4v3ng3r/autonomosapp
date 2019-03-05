import 'dart:async';

import 'package:autonomosapp/bloc/ServiceListWidgetBloc.dart';
import 'package:autonomosapp/firebase/FirebaseUfCidadesServicosProfissionaisHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/model/Estado.dart';
import 'package:autonomosapp/model/Location.dart';
import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/ui/screens/LoginScreen.dart';
import 'package:autonomosapp/ui/screens/ProfessionalsMapScreen.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/ProfessionalPersonalInfoRegisterScreen.dart';
import 'package:autonomosapp/ui/widget/FavouritesWidget.dart';
import 'package:autonomosapp/ui/widget/GenericInfoWidget.dart';
import 'package:autonomosapp/ui/widget/ModalRoundedProgressBar.dart';
import 'package:autonomosapp/ui/widget/NetworkFailWidget.dart';
import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/ServiceListWidget.dart';
import 'package:autonomosapp/ui/widget/UsersViewWidget.dart';
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

enum  DrawerOption { PERFIL, SERVICES, VIEWS, FAVORITE, AUTONOMOS, EXIT, DELETE_ACCOUNT }
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
  
  static const Map<DrawerOption, String> _mapOptionTitle = {
    DrawerOption.PERFIL : "Perfil",
    DrawerOption.SERVICES : "Serviços",
    DrawerOption.VIEWS : "Visualizações",
    DrawerOption.FAVORITE : "Meus Favoritos",
    DrawerOption.AUTONOMOS : "Seja um Autônomo",
    DrawerOption.EXIT : "Sair",
    DrawerOption.DELETE_ACCOUNT : "Remover Conta"
  };

  DrawerOption _drawerCurrentOption;
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
    _repository = UserRepository.instance;
    _user = _repository.currentUser;

    _drawerCurrentOption = DrawerOption.SERVICES;
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

  @override
  Widget build(BuildContext context) {
    print("mainscreen build");
    final modal = ModalRoundedProgressBar(
        handleCallback: (handler){
          _progressBarHandler = handler;
        });

    final scaffold= Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          icon: Icon(Icons.menu,),
        ),

        title: Text( _mapOptionTitle[ _drawerCurrentOption] ),
        automaticallyImplyLeading: false,
        elevation: (_drawerCurrentOption == DrawerOption.SERVICES) ? .0 : 4.0,
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

    _setCurrentDrawerOption(DrawerOption.SERVICES);
    return false;
  }

  void _NavegaCadastroAutonomo(BuildContext context) {
    Navigator.pop(context);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => ProfessionalPersonalInfoRegisterScreen(),
    ));
  }

  Drawer _drawerMenuBuild(BuildContext context) {
    List<Widget> drawerOptions = List();

    print("drawer menu build");
    final drawerHeader = UserAccountsHackedDrawerHeader(
      accountEmail: Text('${_user.email}', style: TextStyle(color: Colors.white),),
      accountName: Text('${_user.name}', style: TextStyle(color: Colors.white), ),
      ratingBar: RatingBar(
        color: Theme.of(context).primaryColor,
        starCount: 5,
        rating: _user.rating,
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: (_repository.currentUser.picturePath == null) ?
        AssetImage(Constants.ASSETS_LOGO_USER_PROFILE_FILE_NAME ) :
        CachedNetworkImageProvider(_repository.currentUser.picturePath ),
      ),
    );
    drawerOptions.add(drawerHeader);

    final optionPerfil = ListTile(
      selected: _drawerCurrentOption == DrawerOption.PERFIL,
      leading: Icon(Icons.person),
      title: Text( _mapOptionTitle[DrawerOption.PERFIL] ),
      onTap: () => _setCurrentDrawerOption(DrawerOption.PERFIL),
    );
    drawerOptions.add(optionPerfil);

    final optionServices = ListTile(
      selected: _drawerCurrentOption == DrawerOption.SERVICES,
      leading: Icon(Icons.work),
      title: Text(_mapOptionTitle[DrawerOption.SERVICES]),
      onTap: () {
        _setCurrentDrawerOption(DrawerOption.SERVICES);
      },
    );

    drawerOptions.add(optionServices);

    final optionViews = ListTile(
      selected: _drawerCurrentOption == DrawerOption.VIEWS,
      leading: Icon(Icons.remove_red_eye),
      title: Text(_mapOptionTitle[DrawerOption.VIEWS]),
      onTap: () => _setCurrentDrawerOption(DrawerOption.VIEWS),
    );
    drawerOptions.add(optionViews);

    final optionFavorites = ListTile(
      selected: _drawerCurrentOption == DrawerOption.FAVORITE,
      leading: Icon(Icons.favorite),
      title: Text( _mapOptionTitle[DrawerOption.FAVORITE] ),
      onTap: () => _setCurrentDrawerOption(DrawerOption.FAVORITE),
    );
    drawerOptions.add(optionFavorites);

    if (_user.professionalData == null) {
      print("MainScreen User is not a professional!!!");
      final optionRegister = ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Constants.ASSETS_APP_ICON, ),
                fit: BoxFit.scaleDown,
            ),
          ),
        ),
        title: Text(_mapOptionTitle[DrawerOption.AUTONOMOS],
            style:  TextStyle(fontWeight: FontWeight.bold)),
        onTap: () => _NavegaCadastroAutonomo(context),
      );
      drawerOptions.add(optionRegister);
    }

    drawerOptions.add(Divider());
    final optionLogout = ListTile(
      leading: Icon(Icons.navigate_before),
      title: Text( _mapOptionTitle[DrawerOption.EXIT]),
      onTap: () {
        _logout();
      },
    );
    drawerOptions.add(optionLogout);

    final removeAccount = ListTile(
      leading: Icon(Icons.delete),
      title: Text(_mapOptionTitle[DrawerOption.DELETE_ACCOUNT] ),

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

    final drawer = Drawer(
      key: _drawerKey,
      child: ListView(
        padding: EdgeInsets.all(.0),
        children: drawerOptions,
      ),
    );

    return drawer;
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

  void _setCurrentDrawerOption(DrawerOption option) {

    if (option != _drawerCurrentOption){
      setState(() {
        if (_serviceListFragment == null)
          _initServicesListFragment();
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
        return PerfilDetailsWidget( user: _user );

      case DrawerOption.SERVICES:
        return _serviceListFragment;

      case DrawerOption.VIEWS:
        _serviceListFragment = null;
        return UsersViewWidget();
      
      case DrawerOption.FAVORITE:
        _serviceListFragment = null;
        return Center(
          child: FavouritesWidget(),
        );
      //NUNCA DEVE VIM AQUI!!
      default:
        break;
    }
  }

  void _serviceClickedCallback(Service item) async {

    _progressBarHandler.show( message: "Buscando Profissionais");

      var results = await _updateUserCurrentPosition();
      if (!results) {
        _progressBarHandler.dismiss();
        return;
      }
    _fetchProfessionalsAndGoToMapScreen(item);

  }

  /// faz ua nova consulta à localização do usuário
  /// e atualiza sua posição no repository

  Future<bool> _updateUserCurrentPosition() async {

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

          try {

            placeMarks = await LocationUtility.doGeoCoding( position );
            _placemark = placeMarks[0];
            var location = Location(
                latitude: position.latitude,
                longitude: position.longitude);
            UserRepository().currentLocation = location;
            return true;
          }

          catch (ex){
            print("_updateUserCurrentPosition error geocoding... $ex");
            showDialog(context: context,
                builder: (BuildContext context){
                 return AlertDialog(
                   content: SingleChildScrollView(
                     child: GenericInfoWidget(
                       icon: Icons.info,
                       iconSize: 90,
                       iconColor: Theme.of(context).errorColor,
                       title: "Não foi possível obter Profissionais",
                       titleColor: Theme.of(context).accentColor,
                       subtitle: "Verifique sua conexão com a internet."
                     ),
                   ),
                 );
                }
            );
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

  void _showNetworkFailDialog(){
    showDialog(context: context,
      barrierDismissible: true,
      builder: (context){
        return SimpleDialog(
          children: <Widget>[
            NetworkFailWidget(),
          ],
        );
      }
    );
  }


  void _fetchProfessionalsAndGoToMapScreen(Service serviceItem)  async {
    String sigla = Estado.keyOfState(_placemark.administrativeArea);

    FirebaseUfCidadesServicosProfissionaisHelper
        .getProfessionalsIdsFromCityAndService( estadoSigla: sigla,
        cidadeNome: _placemark.subAdministrativeArea,
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

                }).catchError(
                    (exception) {
                  if(exception.runtimeType == TimeoutException){
                    _showNetworkFailDialog();
                  }

                  else print("capturei excessao na main screen");
                  _progressBarHandler.dismiss();
                  return;
                });
          }

          else {
            // EH PQ NAO HA PROFISISONAIS PARA TAL SERVICO EM TAL CIDADE!
            //desbloquear tela
            print("Nao ha profissionais");
            _progressBarHandler.dismiss();
            _showWarningSnackbar(serviceItem.name, _placemark.subAdministrativeArea);

          }
        }).catchError(
            (ex){
          print( "MainScreen fetching pro error! $ex" );
          _progressBarHandler.dismiss();
          _showNetworkFailDialog();
        });
  }

  void _showWarningSnackbar(String serviceName,String cityName){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Não há profissonais para $serviceName"
            " disponíveis em $cityName",),
          backgroundColor: Colors.red,
        )
    );
  }

} // end of class
