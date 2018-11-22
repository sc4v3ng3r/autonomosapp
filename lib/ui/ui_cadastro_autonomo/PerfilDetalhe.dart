import 'package:flutter/material.dart';

class PerfilDetalhe extends StatefulWidget{
  @override
  PerfilDetalheState createState()=> PerfilDetalheState();

}

class PerfilDetalheState extends State<PerfilDetalhe>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(color: Colors.black87),),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.red[400]),
      ),
    );
  }

}