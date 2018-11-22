import 'package:flutter/material.dart';

class CadastroAutonomoPt1 extends StatefulWidget{
  @override
  CadastroAutonomoPt1State createState() => CadastroAutonomoPt1State();
}

class CadastroAutonomoPt1State extends State<CadastroAutonomoPt1>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informações Básicas',
          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red),
      ),
    );
    // TODO: implement build
  }

}