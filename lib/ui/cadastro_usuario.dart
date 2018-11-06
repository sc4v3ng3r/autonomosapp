import 'package:flutter/material.dart';

class CadastroUsuarioActivity extends StatefulWidget {

  @override
  CadastroUsuarioState createState() => new CadastroUsuarioState();
}

class CadastroUsuarioState extends State<CadastroUsuarioActivity>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Cadastro',style: TextStyle(color: Colors.blue),),
        backgroundColor: Colors.yellow,),
      body: FixaDeCadastro(),
    );
  }
}

class FixaDeCadastro extends StatefulWidget{
  @override
  FixaDeCadastroState createState() => new FixaDeCadastroState();

}

class FixaDeCadastroState extends State<FixaDeCadastro>{
  FocusNode _nomeFocus;
  FocusNode _sobrenomeFocos;
  FocusNode _emailFocus;

  @override
  void initState() {
    super.initState();
    _nomeFocus = FocusNode();
    _sobrenomeFocos = FocusNode();
    _emailFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _nomeFocus.dispose();
    _sobrenomeFocos.dispose();
    _emailFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var imagemUser = new Image(
      image: AssetImage('assets/usuario.png'),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );

    final nome = TextFormField(
      decoration: InputDecoration(
        labelText: 'Nome',labelStyle: TextStyle(
        fontSize: 16.0,
      ),),
      maxLines: 1,
      textCapitalization: TextCapitalization.words,
      autofocus: false,
      textInputAction: TextInputAction.next,
      focusNode: _nomeFocus,
      onFieldSubmitted: (dataType){
        _nomeFocus.unfocus();
        FocusScope.of(context).requestFocus(_sobrenomeFocos);
      },
    );
    final sobrenome = TextFormField(
      maxLines: 1,
      decoration: InputDecoration(labelText: 'Sobrenome'),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      autofocus: false,
      focusNode: _sobrenomeFocos,
      onFieldSubmitted: (dataType){
        _sobrenomeFocos.unfocus();
        FocusScope.of(context).requestFocus(_emailFocus);
      },
    );
    final email =TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      focusNode: _emailFocus,
      decoration: InputDecoration( labelText: 'Email'),

    );

    final telefone = TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: 'Telefone'),
    );

    final senha = TextFormField(
      decoration: InputDecoration(
        labelText: 'Senha',

      ),
      obscureText: true,
    );

    final registrarButton = OutlineButton(
      onPressed: () {
        Navigator.pop(context);
      },child: Text('Confirmar Registro',style: TextStyle(color: Colors.black),),
//      color: Colors.green,
//      padding: EdgeInsets.fromLTRB(, top, right, bottom),
    );

    final container_foto_nome = Container(
      height: 150.0,
      width: MediaQuery.of(context).size.width*0.96,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child:imagemUser
          ),
          Expanded(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: nome,
                ),
                Flexible(
                  child: sobrenome,
                ),

              ],
            ),
          )
        ],
      ),
    );

  final corpo = Container(
    height: 400.0,
    width: MediaQuery.of(context).size.width,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: telefone,
        ),
        Flexible(
          child: email,
        ),
        Flexible(
          child: senha,
        ),
        Expanded(
//          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: registrarButton,
              )
            ],
          ),
        )
      ],
    ),
  );
  return ListView(
    padding: EdgeInsets.all(8.0),
    children: <Widget>[
      container_foto_nome,
      corpo
    ],
  );

  }

}