import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRegisterScreen extends StatelessWidget{
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();
  final SizedBox  _verticalSeparator = new SizedBox(height: 24.0,);

  @override
  Widget build(BuildContext context) {
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
          textInputAction: TextInputAction.next,
          focusNode: _passwordFocus,
          onFieldSubmitted: (dataTyped){
            _passwordFocus.unfocus();
            FocusScope.of(context).requestFocus(_passwordConfirmFocus);
          },
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

    final passwordConfirm = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: TextFormField(
          maxLines: 1,
          autofocus: false,
          obscureText: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          focusNode: _passwordConfirmFocus,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),

          decoration: InputDecoration(
              labelText: "Confirmar Senha",
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

    final registerButton = Material(
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        splashColor: Colors.greenAccent,
        onPressed: () {
          print("confirmar cadastro");

        },
        minWidth: 130.0,
        color: Colors.yellow,
        child: Text(
          "Confirmar",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );

    final cancelButton = Material(
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        splashColor: Colors.red,
        onPressed: () {
          print("cancelar cadastro");
        },
        minWidth: 130.0,
        color: Colors.redAccent,
        child: Text(
          "Cancelar",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, color: Colors.white,),
        ),
      ),
    );

    final buttonsGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        registerButton,
        SizedBox(width: 5.0,),
        cancelButton
      ],
    );

    return
      Scaffold(
        appBar: AppBar(
          title: Text("Registrar"),

        ),
        body:
        Container(
          padding: EdgeInsets.only(top: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                emailField,
                _verticalSeparator,
                passwordField,
                _verticalSeparator,
                passwordConfirm,
                _verticalSeparator,
                buttonsGroup
              ],
            ),
          ),
        ),

      );

  }
}