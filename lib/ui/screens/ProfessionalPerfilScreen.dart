import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/PerfilDetailsWidget.dart';
import 'package:flutter/material.dart';

class ProfessionalPerfilScreen extends StatelessWidget {

  final User _userProData;
  static final _errorWidget = Container(
    child: Material(
      child: Center(
        child: Text("Impossível obter detalhes do usuário."),
      ),
    ),
  );

  ProfessionalPerfilScreen({@required User userProData}) :
        _userProData = userProData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userProData.name ),
      ),

      body: PerfilDetailsWidget(
        editable: false,
        user: _userProData,
      ),

    );
  }

}
