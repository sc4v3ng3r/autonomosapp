import 'package:flutter/material.dart';

class CadastroUsuarioActivity extends StatefulWidget {

  @override
  FixaDeCadastroState createState() => new FixaDeCadastroState();
}

class FixaDeCadastroState extends State<CadastroUsuarioActivity>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //appBar: AppBar(title: Text('Fixa de Cadastro'),),
      title: 'Cadastro',
      theme: ThemeData(primaryColor: Colors.white),
      home:conteudo
    );

  }
  Widget conteudo = Container(
    child: Row(
      mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Estou Aqui',
            style: TextStyle(fontSize: 1.0),
          )
        ],
      ),
  );

}
