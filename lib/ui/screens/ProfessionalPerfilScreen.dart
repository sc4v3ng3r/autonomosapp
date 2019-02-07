import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/PerfilDetailsWidget.dart';
import 'package:flutter/material.dart';
class ProfessionalPerfilScreen extends StatelessWidget {

  final User _userProData;
  final bool _registerView;

  ProfessionalPerfilScreen(
      { @required User userProData, bool registerVisualization = false } ) :
        _registerView = registerVisualization,
        _userProData = userProData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () async {},
            icon: Icon( Icons.phone, color: Colors.white,),
          ),
        ],
        title: Text(_userProData.name ),),

      body: PerfilDetailsWidget(
        editable: false,
        user: _userProData,
      ),
    );
  }

}
