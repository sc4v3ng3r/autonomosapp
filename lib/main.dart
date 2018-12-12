import 'package:autonos_app/ui/screens/LoginScreen.dart';
import 'package:autonos_app/utility/UserRepository.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("My app build()");
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("ScreenSelector build()");
    return FutureBuilder<User>(
      future: FirebaseUserHelper.currentLoggedUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch ( snapshot.connectionState ) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            print("STATE ${snapshot.connectionState.toString()}");
            return Container(color: Colors.transparent,);

            //TODO MELHORAR ESSA VERIFICACAO!
          case ConnectionState.done:
            print("STATE ${snapshot.connectionState.toString()}");
            print("Snapshot:  ${snapshot.data} ");

            if (snapshot.data != null){
              UserRepository().currentUser = snapshot.data;
              return MainScreen();
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