import 'package:flutter/material.dart';

class CadastroUsuarioActivity extends StatefulWidget {

  @override
  FixaDeCadastroState createState() => new FixaDeCadastroState();
}

class FixaDeCadastroState extends State<CadastroUsuarioActivity>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Cadastro',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,),
      body: FixaDeCadastro(),
    );
  }
}
class FixaDeCadastro extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        height: MediaQuery.of(context).size.height*0.84,
        width: MediaQuery.of(context).size.width*0.96,
        color: Colors.white,
      ) ,
    );


  }

}