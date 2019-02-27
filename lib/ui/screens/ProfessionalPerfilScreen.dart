import 'package:autonomosapp/bloc/ProfessionalPerfilScreenBloc.dart';
import 'package:autonomosapp/model/ProfessionalRating.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/FavoriteButtonWidget.dart';
import 'package:autonomosapp/ui/widget/PerfilDetailsWidget.dart';
import 'package:autonomosapp/ui/widget/RateProfessionalDialogWidget.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalPerfilScreen extends StatelessWidget {

  final User _userProData;
  final GlobalKey<FavoriteButtonWidgetState> _favoriteKey = GlobalKey();
  final ProfessionalPerfilScreenBloc _bloc = ProfessionalPerfilScreenBloc();

  ProfessionalPerfilScreen(
      { @required User userProData} ) :
        _userProData = userProData;

  @override
  Widget build(BuildContext context) {
    final actionTrialProfessional = Tooltip(
      message: "Avaliar Profisisonal",
      child: IconButton(
          icon: Icon(Icons.star_half,
            color: Theme.of(context).accentColor,),
          onPressed: (){
            if (_userProData.uid == UserRepository.instance.currentUser.uid)
              return;

            _showQualiticationDialog(context);
          }
      ),
    );

    final actionFavourite = FavoriteButtonWidget(
      favorite: _bloc.isFavorite( _userProData ),
      key: _favoriteKey,
      color: Theme.of(context).accentColor,
      callback: _favoriteButtonCallback,
    );

    final appBar = AppBar(
      actions: <Widget>[
        actionTrialProfessional,
        actionFavourite,
      ],

      title: Text(_userProData.name ),
      brightness: Brightness.dark,
    );

    final scaffoldBody = PerfilDetailsWidget(
      editable: false,
      user: _userProData,
    );

    final bottomWidget = Row(
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
    );

    final scaffold = Scaffold(
      appBar: appBar,
      body: scaffoldBody,
      bottomNavigationBar: bottomWidget,
    );

    return scaffold;
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

  void _showQualiticationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context){
          return RateProfessionalDialogWidget(
            onConfirm: (rate){
              _bloc.rateProfessional(
                ProfessionalRating(
                  proUid: _userProData.uid,
                  userUid: UserRepository.instance.currentUser.uid,
                  rating: rate
                ),
              );
              Navigator.pop(context);
              print("RATE WAS $rate");
            },
          );
      }
    );
  }
  void _favoriteButtonCallback(final FavoriteAction action){
    switch(action){
      case FavoriteAction.FAVORITE:
        if (_userProData.uid == UserRepository.instance.currentUser.uid )
          _favoriteKey.currentState.changeAction(FavoriteAction.UNFAVOURITE);
        else {
          _bloc.addToFavorite(
              UserRepository.instance.currentUser.uid,
              _userProData);
        }
        break;

      case FavoriteAction.UNFAVOURITE:
        _bloc.removeFromFavorites(
            UserRepository.instance.currentUser.uid,
            _userProData);
        break;
    }

  }

}
