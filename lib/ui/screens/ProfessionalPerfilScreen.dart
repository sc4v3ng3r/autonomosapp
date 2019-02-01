import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/model/ProfessionalData.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/PerfilDetailsWidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfessionalPerfilScreen extends StatelessWidget {

  final ProfessionalData _userProData;
  static final _errorWidget = Container(
    child: Material(
      child: Center(
        child: Text("Impossível obter detalhes do usuário."),
      ),
    ),
  );

  ProfessionalPerfilScreen({@required ProfessionalData userProData}) :
        _userProData = userProData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder< DataSnapshot >(
      future: FirebaseUserHelper.readUserNode(uid: _userProData.uid),
      builder: (BuildContext buildContext, AsyncSnapshot<DataSnapshot> snapshot) {
        switch ( snapshot.connectionState ){
          case ConnectionState.none:
            return _errorWidget;
            break;

          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
            break;

          case ConnectionState.done:
            if (snapshot.hasData){
              User proUser = User.fromDataSnapshot(snapshot.data);
              proUser.professionalData = _userProData;
              return Scaffold(
                appBar: AppBar(
                  title: Text(proUser.name),
                ),
                body: PerfilDetailsWidget(
                  editable: false,
                  user: proUser,
                ),

              );
            }
            else {
              return _errorWidget;
            }
            break;
        }
      },
    );
  }

}
