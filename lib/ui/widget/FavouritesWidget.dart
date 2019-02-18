import 'package:autonomosapp/bloc/FavouritesWidgetBloc.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/screens/ProfessionalPerfilScreen.dart';
import 'package:autonomosapp/ui/widget/FavouriteItemListWidget.dart';
import 'package:autonomosapp/ui/widget/GenericInfoWidget.dart';
import 'package:autonomosapp/ui/widget/NetworkFailWidget.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';

class FavouritesWidget extends StatefulWidget {

  final FavouritesWidgetBloc _bloc = FavouritesWidgetBloc();
  
  @override
  _FavouritesWidgetState createState() => _FavouritesWidgetState();

}

class _FavouritesWidgetState extends State<FavouritesWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User> >(
      stream: widget._bloc.favorites,
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot){
        print("FavouritesWidget::build ${snapshot.connectionState}");
        switch(snapshot.connectionState){

          case ConnectionState.none:
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: NetworkFailWidget(),
                ),
              ],
            );
            break;

          case ConnectionState.waiting:
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Constants.VERTICAL_SEPARATOR_8,
                Text("Carregando seus favoritos..."),
              ],
            );
            break;

          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData){
              if (snapshot.data.isEmpty){
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: GenericInfoWidget(
                        icon: Icons.star_border,
                        title: "Você não tem favoritos",
                      ),
                    ),
                  ],
                );
              }

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, final int index){
                    return FavouriteItemListWidget(
                      favoriteUser: snapshot.data[index],
                      onTap: _openPerfilScreen,
                      onDelete: _removeUser,
                    );
                  }
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: NetworkFailWidget(),
                ),
              ],
            );
            break;
        }
      },
    );
  }

  void _removeUser(final User user){
    widget._bloc.removeFavouriteUser(
        UserRepository.instance.currentUser.uid, user);
  }

  void _openPerfilScreen(final User user){
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return ProfessionalPerfilScreen(
            userProData: user,
          );
        })
    );
  }

  @override
  void dispose() {
    widget._bloc?.dispose();
    super.dispose();
  }
}
