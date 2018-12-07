import 'package:autonos_app/bloc/CityListWidgetBloc.dart';
import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/ui/widget/AbstractDataListWidget.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/widget/SearchBarWidget.dart';

class CityListWidget extends StatefulWidget {
  final String _queryKey;
  final _itemSelectedCallback;

  CityListWidget( {String sigla = "BA",
    @required void itemsSelected(List<Cidade> selectedItems) } ) :
        _itemSelectedCallback = itemsSelected,
        _queryKey = sigla;

  @override
  State createState () =>_CityListWidgetState();

}

class _CityListWidgetState extends State<CityListWidget> {
  CityListWidgetBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_bloc != null)
      _bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_CityListWidgetState build()");
    _bloc = CityListWidgetBlocProvider.of(context);
    _bloc.getCity(widget._queryKey);

    _bloc.selectedItems.listen( (itemList) {
      widget._itemSelectedCallback(itemList);
    });

    var searchBar = SearchBarWidget(
      hint: "Pesquisar...",
      color: Colors.red[300],
      onTyped: (String data) {
        _bloc.searchFor( data );
        print(data);
      },
    );

    return StreamBuilder< List<Cidade> >(
      stream: _bloc.allCities,
      builder: (BuildContext context, AsyncSnapshot<List<Cidade>> snapshot) {

        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Column(
              children: <Widget>[
                searchBar,
                CircularProgressIndicator(),
                Text("CARREGANDO..."),
              ],
            );

          case ConnectionState.active:
          case ConnectionState.done:
            print("stream builder");
            return Column(
              children: <Widget>[
                searchBar,
                ListWidget( snapshot.data),
              ],
            );
          case ConnectionState.none:
            return Text("NO CONNECTION!!!");
        }
      },
    );
  }
}


class ListWidget extends AbstractDataListWidget< Cidade > {

  ListWidget(List<Cidade> list) : super( itemList: list );

  @override
  Widget onCreateWidget(Cidade data, int index) {
    return CityItemView(item: data, defaultColor: Colors.white, selectedColor: Colors.green,
    );
  }
}

// essa a classe que deve ser generica
class CityItemView extends StatefulWidget implements Comparable<CityItemView> {
  final Cidade item;

  CityItemView( {@required Cidade item,
    Color defaultColor = Colors.white, Color selectedColor = Colors.green} ) :
      this.item= item;

  @override
  State createState() => _CityItemViewState();

  @override
  int compareTo(CityItemView other) {
    return this.item.id.toString().compareTo( other.item.id.toString());
  }
}

class _CityItemViewState extends State<CityItemView> {

  CityListWidgetBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("_CityItemViewState build()");
    _bloc = CityListWidgetBlocProvider.of(context);

    return Card(
      color: (_bloc.isSelected( widget.item)) ? Colors.green : Colors.white,
      elevation: 5.0,
      child: ListTile(
        title: Text( "${widget.item.nome}", style: TextStyle(fontSize: 20.0)),
        leading: Icon(Icons.location_city),
        onTap: (){
          if (_bloc.isSelected( widget.item ) )
            _bloc.removeItem( widget.item );
          else _bloc.selectItem( widget.item );
          setState(() {});
        },
      ),
    );
  }
}