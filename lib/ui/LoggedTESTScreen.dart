
import 'package:autonos_app/util/RatingBar.dart';
import 'package:flutter/material.dart';

class LoggedScreen extends StatefulWidget {
  @override
  LoggedScreenState createState() => new LoggedScreenState();

}

class LoggedScreenState extends State<LoggedScreen> {

  double rating = 3.5;
  final bool sair = false;
@override
  Widget build(BuildContext context) {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//    return new StarRating(
//    rating: rating,
//    onRatingChanged: (rating) => setState(() => this.rating = rating),
//  );
    return  Scaffold(
      key:_scaffoldKey,
        appBar: AppBar(
//          leading: Icon(Icons.menu,),
//        bottom: IconButton(onPressed: () {_scaffoldKey.currentState.openDrawer();}, icon: Icon(Icons.menu)),
        leading: IconButton(onPressed: () {_scaffoldKey.currentState.openDrawer();}, icon: Icon(Icons.menu),),
//          actions: <Widget>[IconButton(onPressed: () {_scaffoldKey.currentState.openDrawer();}, icon: Icon(Icons.menu),)],
          title:Text("Logged Screen"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
        ),
        drawer:new Drawer(
        child: ListView(
//          padding: EdgeInsets.all(1.0),
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, .0, 12.0, .0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/usuario_drawer.png'),
                      maxRadius: 48.0,),
                  ),

                  Center(
                  child:
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(.0, 5.0, 0.0, 0.0),
                          child: Text('Nome Completo',style: TextStyle(color: Colors.white),),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(.0, 5.0, 0.0, 0.0),
                          child: Text('user@email.com',style: TextStyle(color: Colors.white)),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(.0, 5.0, 0.0, 0.0),
                          child: new StarRating(
                            rating: rating,
//                          onRatingChanged: (rating) => setState(() => this.rating = rating),
                          ),
                        )

                      ],
                    ),
                 )
                ],
              ),
            ),
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
              onTap: (){
                _sairDoLogged(context);
              },

            ),


          ],

        ),),
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

        )
      );
  }

_sairDoLogged(BuildContext context){
    //Sai do drawer
    Navigator.pop(context);
    //Sai da tela  de logado
    Navigator.pop(context);
}

}

