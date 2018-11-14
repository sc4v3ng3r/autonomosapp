import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:autonos_app/model/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widget/UserAccountsHackedDrawerHeader.dart';
import 'widget/RatingBar.dart';
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
    return new Scaffold(
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
          backgroundColor: Colors.indigo[400],
        ),

        drawer: _drawerMenu(context),

        // aqui entram os "FRAGMENTS!"
        body: new Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Bem vindo: ${widget.user.email}"),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Drawer _drawerMenu(BuildContext context) {
    var drawerHeader = Container(
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

    return new Drawer(
      child: ListView(
        padding: EdgeInsets.all(.0),
        children: <Widget>[

          UserAccountsHackedDrawerHeader(
            accountEmail: Text('${widget.user.email}'),
            accountName: Text('${widget.user.name}'),
            ratingBar: RatingBar(starCount: 5, rating: 4.3,),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.red,),
          ),
          /*UserAccountsDrawerHeader(
            accountEmail: Text('${widget.user.email}'),
            accountName: Text('${widget.user.name}'),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.red,),
          ),*/
          //drawerHeader,

          ListTile(
            //contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, .0, .0),
            leading: Icon(Icons.person),
            title: Text('Perfil'),

          ),

          ListTile(
            leading: Icon(Icons.work),
            title: Text('Serviços'),
          ),

          ListTile(
            leading: Icon(Icons.history),
            title: Text('Histórico'),
          ),

          ListTile(
            leading: Icon(Icons.remove_red_eye),
            title: Text('Visualizações'),
          ),

          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favoritos'),
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.navigate_before),
            title: Text('Sair'),
            onTap: () {
//              AlertDialog(title: Text('Tem certeza que você quer sair?'),).build(context);
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
    }).catchError( (onError) {
      //Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/loginScreen');
    });
  }

  _onDrawerItemSelected(int position){
    setState(() {
      _drawerCurrentPosition = position;
      // atualiza a tela!
    });

    // fecha o drawer!
  }
  Widget _getDrawerItemScreen(int position){
    return null;
  }
}// end of class
