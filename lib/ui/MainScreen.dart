import 'package:autonos_app/ui/ui_cadastro_autonomo/ProfessionalRegisterBasicInfoScreen.dart';
import 'package:autonos_app/ui/widget/CityListWidget.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widget/UserAccountsHackedDrawerHeader.dart';
import 'widget/RatingBar.dart';
import 'package:autonos_app/ui/ClientChooseServicesFragment.dart';

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
  int _drawerCurrentPosition = 1;

  @override
  Widget build(BuildContext context) {
    print("LoginScreen::BuildMethod");

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
      MaterialPageRoute(builder: (BuildContext context) => ProfessionalRegisterBasicInfoScreen()));

}
  @override
  void initState() {
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
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
            onTap: ()=>_NavegaCadastroAutonomo(context),
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
      //Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/loginScreen');

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

    Navigator.of(context).pop();
  }

  Widget _getFragment(int position){
    switch (position){
      case 0:
        return CityListWidget();
        /*return Center(
          child: Text("Perfil Screen"),
        );
      */
      case 1:
        return Center(
          child: ClientChooseServicesFragment(),
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


/*
   ANTIGO DRAWER HEADER
*  var drawerHeader = Container(
      height: 128.0,
      color: Colors.cyanAccent[400],

      child: DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.cyanAccent[400],
        ),

        margin: EdgeInsets.all(.0),
        padding: EdgeInsets.all(.0),

        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(2.0, .0, 12.0, .0),
              child: CircleAvatar(
                backgroundColor: Colors.indigo[400],
                backgroundImage: AssetImage('assets/usuario_drawer.png'),
                maxRadius: 48.0,
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(.0, 8.0, 0.0, 0.0),
                    child: Text( widget.user.name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(.0, 8.0, 0.0, 0.0),
                    child: Text( widget.user.email,
                        style: TextStyle(color: Colors.white)),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(.0, 8.0, .0, .0),
                        child: RatingBar(
                          rating: widget.user.rating,
//                          onRatingChanged: (rating) => setState(() => this.rating = rating),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4.0, 8.0, .0, .0),
                        child: Text( "${widget.user.rating}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
*
* */