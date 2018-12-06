import 'package:autonos_app/bloc/CityListWidgetBloc.dart';
import 'package:autonos_app/model/Cidade.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/widget/SearchBarWidget.dart';

class CityListWidget extends StatelessWidget {

  CityListWidgetBloc _bloc = CityListWidgetBloc();

  @override
  Widget build(BuildContext context) {

    return _createBody(context);
  }

  Widget _createBody(BuildContext context) {
    _bloc.getCity("BA");

    var searchBar = SearchBarWidget(
      hint: "Pesquisar...",
      color: Colors.red[300],
      onTyped: (String data) {
        _bloc.searchFor(data);
        print(data);
      },
    );

    return StreamBuilder<List<Cidade>>(
      stream: _bloc.allCities,
      builder: (BuildContext context, AsyncSnapshot<List<Cidade>> snapshot) {

        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Column(
              children: <Widget>[
                searchBar,
                Text("CARREGANDO..."),
              ],
            );

          case ConnectionState.active:
          case ConnectionState.done:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                searchBar,
                ListView.builder(
                  shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      ListTile (
                          title: Text(snapshot.data[index].nome),
                          onTap: () => print(snapshot.data[index].nome)
                      );
                    }
                ),

              ],
            );

          case ConnectionState.none:
            return Center(
              child: Text("NO CONNECTION!!!"),
            );
        }
        return searchBar;
      },
    );
  }
}

class CityListItem {
  Cidade cidade;
  Color corItem;

  CityListItem(Cidade cidade, var corItem)
      : this.cidade = cidade,
        this.corItem = corItem;
}

class BlocProvider extends InheritedWidget {


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

}