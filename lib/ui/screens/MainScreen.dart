import 'package:autonos_app/bloc/ServiceListWidgetBloc.dart';
import 'package:autonos_app/ui/screens/LoginScreen.dart';
import 'package:autonos_app/ui/screens/PerfilUsuario.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ProfessionalRegisterBasicInfoScreen.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/widget/ServiceListWidget.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonos_app/ui/widget/UserAccountsHackedDrawerHeader.dart';

class MainScreen extends StatefulWidget {
  //final User user;
  MainScreen( {Key key} ) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  final bool sair = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //var _perfilFragment;
  int _drawerCurrentPosition = 1;
  String appBarName = 'Serviços';
  Color appBarColor = Colors.red[300];
  User _user;

  @override
  void initState() {
    print("Main initState");
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _user = UserRepository().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    print("MainScreen build()");
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
          title: Text(appBarName),
          automaticallyImplyLeading: false,
          backgroundColor: appBarColor,
          elevation: .0,
        ),

        drawer: _drawerMenu(context),
        body: _getFragment( _drawerCurrentPosition ),
    );
  }

void _NavegaCadastroAutonomo(BuildContext context){
  Navigator.pop(context);

  Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) =>
           ProfessionalRegisterBasicInfoScreen(),
      )
  );

}


  Drawer _drawerMenu(BuildContext context) {

    List<Widget> drawerOptions = List();

    final drawerHeader = UserAccountsHackedDrawerHeader(
      accountEmail: Text('${_user.email}'),
      accountName: Text('${_user.name}'),
      ratingBar: RatingBar(starCount: 5, rating: 4.3,),
      currentAccountPicture: CircleAvatar(backgroundColor: Colors.white,),
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

    final optionViews =ListTile(
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

    // TODO IF (CONDITION)
    if (_user.professionalData == null) {
      print("MainScreen User is not a professional!!!");
      final optionRegister =  ListTile(
        leading: Icon(Icons.directions_walk,color: Colors.red[500],),
        title: Text('Seja Um Autônomo!!!',style: TextStyle(color: Colors.red[500],fontWeight: FontWeight.bold)),
        onTap: ()=> _NavegaCadastroAutonomo(context),
      );
      drawerOptions.add( optionRegister);
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

  _logout(){
    _auth.signOut();
    //TODO WORK AROUND USER REPOSITORY
    UserRepository r = new UserRepository();
    r.currentUser = null;

    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                LoginScreen() ),
            (Route<dynamic> route)  => false);
  }

  void _changeAppBarName(int position){
    if(position == 0){
        appBarColor = Colors.green[300];
        appBarName = 'Perfil';
    }else if(position == 1){
        appBarColor = Colors.red[300];
        appBarName = 'Serviços';
    }else if(position == 2){
      appBarColor = Colors.red[300];
      appBarName = 'Histórico';
    }else if(position == 3){
      appBarColor = Colors.red[300];
      appBarName = 'Visualizações';
    }else if(position == 4){
      appBarColor = Colors.red[300];
      appBarName = 'Favoritos';
    }
  }
  void _setCurrentPosition(int position){

    setState(() => _changeAppBarName(position));

    if (position != _drawerCurrentPosition)
      setState(() => _drawerCurrentPosition = position);

    // coloca o drawer p/ traz??
    Navigator.of(context).pop();
  }

  Widget _getFragment(int position){
    switch (position){
      case 0:
        return Center(
            child: PerfilUsuario()
        );

      case 1:
        return Center(
          child: ServiceListWidgetBlocProvider(
              child: ServiceListWidget(
                itemsSelectedCallback: null,
                clickMode: ClickMode.TAP,
                singleClickCallback: (item) {
                  print("MainScreen clicou em $item");
                },
              ),//ClientChooseServicesFragment(),
          ),
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

}// end of class