import 'package:autonomosapp/ui/screens/LoginScreen.dart';
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
    UserRepository();
    print("Myapp build()");

    return FutureBuilder<User>(
      future: FirebaseUserHelper.currentLoggedUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            print("STATE ${snapshot.connectionState.toString()}");
            return Container(
              color: Colors.black,
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
}// end of class