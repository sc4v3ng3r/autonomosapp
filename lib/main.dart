
import 'package:autonos_app/ui/LoggedTESTScreen.dart';
import 'package:autonos_app/ui/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';


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
            home:SplashScreen(
            seconds: 2,
          title: Text('Autonomos',style: TextStyle(fontFamily: 'cursive',fontSize: 22.0),),
          backgroundColor: Colors.white,
          photoSize: 100.0,
          loaderColor: Colors.cyanAccent,
              navigateAfterSeconds: new SeletorTelas(),
        ));
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      initialRoute: '/',
//      routes: {
//        '/loginScreen': (context) => LoginScreen(),
//        '/logedScreen': (context) => LoggedScreen()
//      },
//      home: SplashScreen(
//
//      )
//    );
  }
}

class SeletorTelas extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/loginScreen': (context) => LoginScreen(),
        '/logedScreen': (context) => LoggedScreen()
      },
      home: new LoginScreen(),

    );
  }

}