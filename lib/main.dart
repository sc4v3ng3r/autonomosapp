import 'package:autonos_app/cadastro_usuario.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
      @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CadastroUsuarioActivity()
    );
  }
}