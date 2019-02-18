import 'dart:async';
import 'package:autonomosapp/ui/screens/LoginScreen.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/screens/MainScreen.dart';
// Marcelo
/*(71)991259223*/
void main() {
  runApp( new MyApp() );
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    UserRepository repo = UserRepository.instance;
    print("Myapp build()");

    return FutureBuilder<User>(
      future: FirebaseUserHelper.currentLoggedUser()
          .timeout(Duration(seconds: Constants.NETWORK_TIMEOUT_SECONDS),
          onTimeout: (){ throw TimeoutException("timeout!!");}),

      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Material(
              color: Colors.grey[350],
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );

          case ConnectionState.done:

            repo.currentUser = snapshot.data;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Autônomos",
              home: (repo.currentUser == null) ? LoginScreen() : MainScreen(),
              theme: ThemeData(
                primaryColor: Colors.amber,
                accentColor: Colors.black,
                errorColor: Colors.red,
                cursorColor: Colors.black,
                textSelectionHandleColor: Colors.black,
              ),

            );
            break;
        }
      },
    );
  }
}// end of class