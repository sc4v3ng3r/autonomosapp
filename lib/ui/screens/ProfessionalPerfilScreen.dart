import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/PerfilDetailsWidget.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalPerfilScreen extends StatelessWidget {

  final User _userProData;
  ProfessionalPerfilScreen(
      { @required User userProData} ) :
        _userProData = userProData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userProData.name ),
        brightness: Brightness.dark,
      ),

      body: PerfilDetailsWidget(
        editable: false,
        user: _userProData,
      ),

      bottomNavigationBar: Row(
        mainAxisSize: MainAxisSize.max,

        children: <Widget>[
          Expanded(
            child: RaisedButton(
              child: Text("Contactar no Whatsapp",
                style: TextStyle(color: Colors.white)
              ),
            onPressed: () async {

              var whatsUrl =
                  "whatsapp://send?phone=55${_userProData.professionalData.telefone}"
                  "&text=${Constants.getDefaultWhatsappMessage(
                  professionalName: _userProData.name)}";

              await canLaunch(whatsUrl) ?
              launch(whatsUrl):
              _showNoWhatsappDialog(context);
            },
            color: Colors.green,
          ),
          ),

        ],
      ),
    );
  }


  //TODO transformar em metodo generico
  void _showNoWhatsappDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Whatsapp não está instalado"),
                ],
              ),
            ),
          );
        }
    );
  }

}
