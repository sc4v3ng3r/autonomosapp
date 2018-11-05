import 'package:flutter/material.dart';

class LoggedScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Logged Screen"),
        ),

        body: Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Voce esta logado!"),
            ],
          ),
        )
      ),
    );
  }
}