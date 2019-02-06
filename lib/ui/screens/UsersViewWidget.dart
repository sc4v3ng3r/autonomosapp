import 'package:autonomosapp/bloc/UsersViewWidgetBloc.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/model/UserView.dart';
import 'package:autonomosapp/ui/widget/UserViewItemWidget.dart';
import 'package:flutter/material.dart';

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
        switch( snapshot.connectionState){
          case ConnectionState.none:
            return Center(
              child: Text("Não foi possível obter suas visualizações"),
            );

          case ConnectionState.waiting:
            print("connection waiting");
            return Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.done:
          case ConnectionState.active:
            if (snapshot.hasData){
              if (snapshot.data.isNotEmpty){
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      var map = snapshot.data[index];
                      var currentKey = map.keys.first;
                      return Card(
                        child: UserViewItemWidget(
                          user:  map[ currentKey ], //widget._userList[index],
                          view: currentKey,
                        ),
                        elevation: 2.0,
                      );
                    });
              }
              else {
                return Center(
                  child: Text("Não há visualizações!"),
                );
              }
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
