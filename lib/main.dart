
import 'package:autonos_app/ui/LoggedScreen.dart';
import 'package:autonos_app/ui/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/loginScreen': (context) => LoginScreen(),
              '/logedScreen': (context) => LoggedScreen(),
            },
            home: ScreenSelector(),
        ); //);
  }
}

class ScreenSelector extends StatefulWidget {

  @override
  State createState() => ScreenSelectorState();

}


class ScreenSelectorState extends State<ScreenSelector>{

  static final _container = Container(color: Colors.transparent,);
  Future<FirebaseUser> _future;
  @override
  void initState() {
    super.initState();
    _future = FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<FirebaseUser>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            print("STATE ${snapshot.connectionState.toString()}");
            return _container;

          case ConnectionState.done:
            print("STATE ${snapshot.connectionState.toString()}");
            if (snapshot.data == null){
              print("NO USER!!!");
              return LoginScreen();
            }

            print("${snapshot.data.email}");
            return LoggedScreen();
        }
        //TODO fazer uma tela especial, pois provavelmente nao ha conexao!!
        return LoginScreen();
      },
    );
  }
}