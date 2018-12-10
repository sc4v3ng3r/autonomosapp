import 'package:autonos_app/model/Service.dart';
import 'package:autonos_app/ui/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/screens/UserRegisterScreen.dart';
import 'package:autonos_app/firebase/FirebaseUserHelper.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/screens/MainScreen.dart';

void main() {
  runApp( new MyApp() );
}

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
              '/userRegisterScreen' : (context) => UserRegisterScreen(),
            },
            home: ScreenSelector(),
        );
  }
}

class ScreenSelector extends StatefulWidget {
  @override
  State createState() => _ScreenSelectorState();

}// Marcelo
/*(71)991259223*/

class _ScreenSelectorState extends State<ScreenSelector>{

  var _container;
  //Future<FirebaseUser> _future;
  @override
  void initState() {
    _container = Container(color: Colors.transparent,);
    super.initState();
    //_future = ;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<User>(
      future: FirebaseUserHelper.currentLoggedUser(),/*_future,*/
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch ( snapshot.connectionState ) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            print("STATE ${snapshot.connectionState.toString()}");
            return _container;

            //TODO MELHORAR ESSA VERIFICACAO!
          case ConnectionState.done:
            print("STATE ${snapshot.connectionState.toString()}");
            print("Snapshot:  ${snapshot.data} ");

            if (snapshot.data != null){
              return MainScreen(user: snapshot.data);
            }

            else {
              print("Main class NO USER DATA!");
              return LoginScreen();
            }

        }
      },
    );
  }

}