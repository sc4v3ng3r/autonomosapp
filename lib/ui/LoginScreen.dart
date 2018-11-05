import 'package:flutter/material.dart';
import 'LoggedTESTScreen.dart';
import 'package:autonos_app/cadastro_usuario.dart';
import 'UserRegisterScreen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: InputGroup(),
    );
  }
}

class InputGroup extends StatelessWidget {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final SizedBox _VERTICAL_SEPARATOR = SizedBox(height: 16.0,);

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      //padding: EdgeInsets.all(26.0),
      width: double.infinity,
      height: 150.0,
      child: Center(
        child: Text(
          "Autônomos",
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            color: Colors.cyan,
            fontSize: 50.0,
            fontFamily: "cursive",
          ),
        ),
      ),
    );

    final emailField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: TextFormField(
          maxLines: 1,
          autofocus: false,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          focusNode: _emailFocus,
          onFieldSubmitted: (dataTyped) {
            print(dataTyped);
            _emailFocus.unfocus();
            FocusScope.of(context).requestFocus(_passwordFocus);
          },

          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),

        decoration: InputDecoration(
            labelText: "E-mail",
            labelStyle: TextStyle(
              fontSize: 18.0,
            ),

            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder( borderRadius: BorderRadius.circular(22.0)) ),
      ),
     ),
    );

    final passwordField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        obscureText: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocus,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),

        decoration: InputDecoration(
            labelText: "Senha",
            labelStyle: TextStyle(
              fontSize: 18.0,
            ),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(22.0))
        ),
        ),
      ),
    );

    final buttonGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(
              splashColor: Colors.yellowAccent,
              onPressed: () {
                logar(context);
              },
              minWidth: 130.0,
              color: Colors.green,
              child: Text(
                "Entrar",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),

        SizedBox(width: 5.0),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(
              splashColor: Colors.greenAccent,
              onPressed: () {
                print("realizar cadastro");
                cadastrar(context);
              },
              minWidth: 130.0,
              color: Colors.yellow,
              child: Text(
                "Cadastre-se",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      );

    final forgotPassword =
    Container(
      width: 150.0,
      child: FlatButton(

        onPressed: () {
          print("Esqueceu a senha...");
        },
        color: Colors.transparent,
        child: Text(
          "Esqueceu a Senha?",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return
      Center(
        child: ListView(

          children: <Widget>[
            _VERTICAL_SEPARATOR,
            logo,
            _VERTICAL_SEPARATOR,
            emailField,
            _VERTICAL_SEPARATOR,
            passwordField,
            _VERTICAL_SEPARATOR,
            buttonGroup,
            forgotPassword
          ],
        ),

    );
  }

  void logar(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else
      Navigator.of(context)
          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return LoggedScreen();
      }));
  }

  void cadastrar(BuildContext context){
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else
      Navigator.of(context)
          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return UserRegisterScreen();
      }));
  }
} // InputGroup
