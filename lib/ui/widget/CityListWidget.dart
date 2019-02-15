import 'package:autonomosapp/bloc/CityListWidgetBloc.dart';
import 'package:autonomosapp/model/Cidade.dart';
import 'package:autonomosapp/ui/widget/AbstractDataListWidget.dart';
import 'package:autonomosapp/ui/widget/NetworkFailWidget.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/SearchBarWidget.dart';

class CityListWidget extends StatefulWidget {
  final String _queryKey;
  final _itemSelectedCallback;
  final List<Cidade>_initialSelectedItems;
  //final

  CityListWidget( {@required String sigla,
    @required void itemsSelectedCallback(List<Cidade> selectedItems), List<Cidade> initialSelectedItems  } ) :
        _itemSelectedCallback = itemsSelectedCallback,
        _initialSelectedItems = initialSelectedItems,
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
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print("_CityListWidgetState build()");
    _bloc = CityListWidgetBlocProvider.of(context);
    _bloc.getCity(key: widget._queryKey);

    _bloc.selectedItems.listen( (itemList) {
      widget._itemSelectedCallback(itemList);
    });

    if( (widget._initialSelectedItems != null) && (widget._initialSelectedItems.isNotEmpty)){
      _bloc.selectItems(widget._initialSelectedItems);
      widget._initialSelectedItems.clear();
    }

    var searchBar = SearchBarWidget(
      hint: "Pesquisar...",
      onTyped: (String data) {
        _bloc.searchFor( data );
        print(data);
      },
    );

    return StreamBuilder< List<Cidade> >(
      stream: _bloc.allCities,
      builder: (BuildContext context, AsyncSnapshot<List<Cidade>> snapshot) {
        print("CityListWIdget current state ${snapshot?.connectionState}");
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                searchBar,
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      Constants.VERTICAL_SEPARATOR_8,
                      Center(
                        child: Text("Carregando Cidades..."),
                      ),
                    ],
                  ),
                ),
              ],
            );

          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData){
              return Column(
                children: <Widget>[
                  searchBar,
                  ListWidget(
                      snapshot.data
                  ),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Center(
                  child: NetworkFailWidget(),
                ),
              ],
            );
            //print("stream builder");

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
//
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
    return this.item.id.toString().compareTo( other.item.id.toString() );
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
    _bloc = CityListWidgetBlocProvider.of(context);

    return
      Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Card(
          color: (_bloc.isSelected( widget.item)) ? Colors.green[300] : Colors.white,
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
        ),
      );
  }
}