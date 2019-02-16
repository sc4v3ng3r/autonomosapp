import 'package:autonomosapp/bloc/UsersViewWidgetBloc.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/model/UserView.dart';
import 'package:autonomosapp/ui/widget/GenericInfoWidget.dart';
import 'package:autonomosapp/ui/widget/UserVisualizationListItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/NetworkFailWidget.dart';

/// Classe utilizada como "fragment" que exibe as viesualizações de um usuário
class UsersViewWidget extends StatefulWidget {

  final UsersViewWidgetBloc _bloc = UsersViewWidgetBloc();

  @override
  _UsersViewWidgetState createState() => _UsersViewWidgetState();
}

class _UsersViewWidgetState extends State<UsersViewWidget> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder< List< Map<UserView, User> >  >(
      stream: widget._bloc.dataUiStream,
      builder: (BuildContext context, AsyncSnapshot< List< Map<UserView, User> > > snapshot ){
        print("Current state ${snapshot.connectionState}");
        switch( snapshot.connectionState){

          case ConnectionState.none:
            return Center(
              child: Text("Não foi possível obter suas visualizações"),
            );

          case ConnectionState.waiting:

            return Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.done:
          case ConnectionState.active:

            if (snapshot.hasData){
              print("Snapshot data ${snapshot.data}");
              if (snapshot.data.isNotEmpty){
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      var map = snapshot.data[index];
                      var currentKey = map.keys.first;
                      return Card(
                        child: UserVisualizationListItemWidget(
                          user:  map[ currentKey ], //widget._userList[index],
                          view: currentKey,
                        ),
                        elevation: 2.0,
                      );
                    });
              }
              else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Center(
                      child: GenericInfoWidget(
                        icon: Icons.sentiment_dissatisfied,
                        title: "Não há visualizações",
                        subtitle: "Seu perfil ainda não possui visualizações",
                      ),
                    ),
                  ],
                );
              }
            }
            else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NetworkFailWidget(),
                ],
              );
            }
        }

      },
    );
  }

  @override
  void dispose() {
    widget._bloc.dispose();
    super.dispose();
  }
}
