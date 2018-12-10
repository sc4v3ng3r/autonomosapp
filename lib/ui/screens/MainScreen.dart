import 'package:autonos_app/bloc/ServiceListWidgetBloc.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ProfessionalRegisterBasicInfoScreen.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/widget/ServiceListWidget.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonos_app/ui/widget/UserAccountsHackedDrawerHeader.dart';

class MainScreen extends StatefulWidget {
  final User user;

  MainScreen( {Key key, @required this.user} ) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  final bool sair = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //var _perfilFragment;
  int _drawerCurrentPosition = 1;


  @override
  void initState() {
    print("Main initState");
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    //_perfilFragment =  CityListWidgetBlocProvider(
    //    child: CityListWidget() );
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
          title: Text("Main Screen"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red[300],
          elevation: .0,
        ),

        drawer: _drawerMenu(context),
        body: _getFragment( _drawerCurrentPosition ),
    );
  }

void _NavegaCadastroAutonomo(BuildContext context){
  Navigator.pop(context);

  Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) =>
          ProfessionalRegisterBasicInfoScreen()
      )
  );

}

  Drawer _drawerMenu(BuildContext context) {
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.all(.0),
        children: <Widget>[

          UserAccountsHackedDrawerHeader(
            accountEmail: Text('${widget.user.email}'),
            accountName: Text('${widget.user.name}'),
            ratingBar: RatingBar(starCount: 5, rating: 4.3,),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.white,),
          ),

          ListTile(
            //contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, .0, .0),
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () => _setCurrentPosition(0),
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Serviços'),
            onTap: () {
              _setCurrentPosition(1);
            },
          ),

          ListTile(
            leading: Icon(Icons.history),
            title: Text('Histórico'),
            onTap: () => _setCurrentPosition(2),
          ),

          ListTile(
            leading: Icon(Icons.remove_red_eye),
            title: Text('Visualizações'),
            onTap: () => _setCurrentPosition(3),
          ),

          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favoritos'),
            onTap: () => _setCurrentPosition(4),
          ),
//          Divider(),

          ListTile(
            leading: Icon(Icons.directions_walk,color: Colors.red[500],),
            title: Text('Seja Um Autônomo!!!',style: TextStyle(color: Colors.red[500],fontWeight: FontWeight.bold)),
            onTap: ()=> _NavegaCadastroAutonomo(context),
//            onTap: () => Navigator.push(
//                context,
//                MaterialPageRoute(builder: (BuildContext context) => CadastroAutonomoPt1())),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.navigate_before),
            title: Text('Sair'),
            onTap: () {
                _logout();
            },
          ),
        ],
      ),
    );
  }

  _logout(){
    _auth.signOut().then((_){
      Navigator.pop(context);

      Navigator.pushNamed(context, '/loginScreen');

      //TODO WORK AROUND USER REPOSITORY
      UserRepository r = new UserRepository();
      r.currentUser = null;

    }).catchError( (onError) {
      //Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/loginScreen');
    });
  }

  void _setCurrentPosition(int position){
    if (position != _drawerCurrentPosition)
      setState(() => _drawerCurrentPosition = position);

    // coloca o drawer p/ traz??
    Navigator.of(context).pop();
  }

  Widget _getFragment(int position){
    switch (position){
      case 0:
        return Center(
            child: Text("Perfil")
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