import 'package:autonos_app/bloc/ServiceListWidgetBloc.dart';
import 'package:autonos_app/firebase/FirebaseUfCidadesServicosProfissionaisHelper.dart';
import 'package:autonos_app/firebase/FirebaseUserHelper.dart';
import 'package:autonos_app/model/Estado.dart';
import 'package:autonos_app/model/Location.dart';
import 'package:autonos_app/model/ProfessionalData.dart';
import 'package:autonos_app/model/Service.dart';
import 'package:autonos_app/ui/screens/LoginScreen.dart';
import 'package:autonos_app/ui/screens/PerfilUsuario.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ProfessionalRegisterBasicInfoScreen.dart';
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
  int _drawerCurrentPosition = 1;
  String appBarName = 'Serviços';
  Color appBarColor = Colors.red[300];
  Color appBarNameColor = Colors.white;
  Color appBarIconMenuColor = Colors.white;
  double _elevation = .0;
  User _user;
  Placemark _placemark;
  ProgressBarHandler _progressBarHandler;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _user = UserRepository().currentUser;
    _initUserCurrentPosition();
    print("Main initState");
    _scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {

    var modal = ModalRoundedProgressBar(
        message: "Buscando Profissionais...",
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

    final drawerHeader = UserAccountsHackedDrawerHeader(
      accountEmail: Text('${_user.email}'),
      accountName: Text('${_user.name}'),
      ratingBar: RatingBar(
        starCount: 5,
        rating: 4.3,
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
      ),
    );
    drawerOptions.add(drawerHeader);

    final optionPerfil = ListTile(
      leading: Icon(Icons.person),
      title: Text('Perfil'),
      onTap: () => _setCurrentPosition(0),
    );
    drawerOptions.add(optionPerfil);

    final optionServices = ListTile(
      leading: Icon(Icons.work),
      title: Text('Serviços'),
      onTap: () {
        _setCurrentPosition(1);
      },
    );
    drawerOptions.add(optionServices);

    final optionHistory = ListTile(
      leading: Icon(Icons.history),
      title: Text('Histórico'),
      onTap: () => _setCurrentPosition(2),
    );
    drawerOptions.add(optionHistory);

    final optionViews = ListTile(
      leading: Icon(Icons.remove_red_eye),
      title: Text('Visualizações'),
      onTap: () => _setCurrentPosition(3),
    );
    drawerOptions.add(optionViews);

    final optionFavorites = ListTile(
      leading: Icon(Icons.favorite),
      title: Text('Favoritos'),
      onTap: () => _setCurrentPosition(4),
    );
    drawerOptions.add(optionFavorites);

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

    return new Drawer(
      child: ListView(
        padding: EdgeInsets.all(.0),
        children: drawerOptions,
      ),
    );
  }

  _logout() {
    _auth.signOut();
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
        return Center(child: PerfilUsuario());

      case 1:
        return ServiceListWidgetBlocProvider(
          child: ServiceListWidget(
            itemsSelectedCallback: null,
            clickMode: ClickMode.TAP,
            singleClickCallback: (item) {
              _serviceListItemClickHandle(item);
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

  void _serviceListItemClickHandle(Service item) async {
    //Position location = await LocationUtility.getCurrentPosition();
    Location location = UserRepository().currentLocation;
    if (location == null) {
      LocationUtility.getCurrentPosition().then((position) {
        if (position == null) {
          print("NAO FOI POSSIVEL BOBTER A POSICAO ATUAL!!");
          //possivelmente o usuario nao deu a permissao de obter a posicao!
          // avisamos  a ele que nao podera seguir!!
        } else {
          // temos a localizacao,
          _goAhead(location, item);
        }
      }).catchError((error) {
        print(error);
      });
    }

    else {
      _goAhead(location, item);
    }
  }

  void _initUserCurrentPosition(){
    LocationUtility.getCurrentPosition().then( (position) {
      if (position != null){
        LocationUtility.doGeoCoding( position )
            .then( (placeMarks){
              _placemark = placeMarks[0];

        }).catchError( (error) { throw error;});

        var location = new Location(
            latitude: position.latitude, longitude: position.longitude);
        UserRepository().currentLocation = location;

      }

      else {
        var snack = SnackBar(
          content: Text("Não foi possível obter sua localização"),
          backgroundColor: Colors.red,);
          Scaffold.of(context).showSnackBar(snack);
      }
    })
    .catchError((error) {
      print(error);
    });
  }

  // TODO método denome provisorio!
  void _goAhead(Location location, Service serviceItem) async {
      String sigla = Estado.keyOfState(_placemark.administrativeArea);

      _progressBarHandler.show();
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
