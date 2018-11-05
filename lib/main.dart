import 'package:autonos_app/ui/cadastro_usuario.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/LoginScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
      @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}