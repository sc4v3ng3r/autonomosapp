import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoggedScreen extends StatefulWidget {
  @override
  LoggedScreenState createState() => new LoggedScreenState();
}

class LoggedScreenState extends State<LoggedScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  double rating = 3.5;
  final bool sair = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

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
          title: Text("Logged Screen"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo[400],
        ),
        drawer: _drawerMenu(context),
        body: new Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Voce esta logado!"),
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
    return new Drawer(
      child: ListView(
//          padding: EdgeInsets.all(1.0),
        children: <Widget>[
          Container(
              height: 128.0,
              color: Colors.cyanAccent,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.cyanAccent[400],
                ),
                margin: EdgeInsets.all(.0),
                padding: EdgeInsets.all(.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, .0, 12.0, .0),
                      child: CircleAvatar(
                        backgroundColor: Colors.indigo[400],
                        backgroundImage:
                            AssetImage('assets/usuario_drawer.png'),
                        maxRadius: 48.0,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(.0, 8.0, 0.0, 0.0),
                            child: Text(
                              'Nome Completo Da Silva',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(.0, 8.0, 0.0, 0.0),
                            child: Text('user@email.com',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(.0, 8.0, .0, .0),
                                child: StarRating(
                                  rating: rating,
//                          onRatingChanged: (rating) => setState(() => this.rating = rating),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4.0, 8.0, .0, .0),
                                child: Text(
                                  '($rating)',
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
              )),
          ListTile(
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
          ListTile(
            leading: Icon(Icons.navigate_before),
            title: Text('Sair'),
            onTap: () {
//              AlertDialog(title: Text('Tem certeza que você quer sair?'),).build(context);


              //SOMENTE TESTE!
              _auth.signOut().then((_){
                Navigator.pushReplacementNamed(context, '/loginScreen');
              }).catchError( (onError) {
                Navigator.pushReplacementNamed(context, '/loginScreen');
              });


            },
          ),
        ],
      ),
    );
  }
}
