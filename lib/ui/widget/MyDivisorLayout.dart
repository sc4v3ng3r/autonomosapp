import 'package:flutter/material.dart';

class MyDivisor {

  Widget _divisorLeft(){
    return Expanded(
        child:Container(
          color: Colors.grey[300],
          height: 1.0,
          padding: EdgeInsets.fromLTRB(16.0, .0, .0, .0),
          margin: EdgeInsets.fromLTRB(16.0,.0, 8.0, .0),
        )
    );
  }

  Widget _divisorRight(){
    return  Expanded(
        child: Container(
          color: Colors.grey[300],
          height: 1.0,
          padding: EdgeInsets.fromLTRB(.0, .0, 16.0, .0),

          margin: EdgeInsets.fromLTRB(8.0,.0, 16.0, .0),)
    );
  }

  Widget _divisor(){
    return Expanded(
        child: Container(
          color: Colors.grey[300],
          height: 1.0,
          padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, .0),

          margin: EdgeInsets.fromLTRB(16.0,.0, 16.0, .0),)
    );
  }

  Widget divisorComplete(){
    return Row(
      children: <Widget>[
        _divisor()
      ],
    );
  }
  Widget divisorGroup(String titulo){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _divisorLeft(),
        Text(titulo, style: TextStyle(color: Colors.grey[500]),),
        _divisorRight()
      ],
    );
  }
}