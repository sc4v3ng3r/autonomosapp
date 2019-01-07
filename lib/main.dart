import 'package:autonos_app/ui/screens/LoginScreen.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/screens/UserRegisterScreen.dart';
import 'package:autonos_app/firebase/FirebaseUserHelper.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/screens/MainScreen.dart';

// Marcelo
/*(71)991259223*/
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
    print("Myapp build()");
    return FutureBuilder<User>(
      future: FirebaseUserHelper.currentLoggedUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot){
        switch ( snapshot.connectionState ){
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            print("STATE ${snapshot.connectionState.toString()}");
            return Container(
              color: Colors.lightGreenAccent,
            );

          case ConnectionState.done:
            UserRepository repo = UserRepository();
            repo.currentUser = snapshot.data;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: (repo.currentUser == null) ? LoginScreen() : MainScreen(),
            );
            break;

        }
      },
    );
  }
}