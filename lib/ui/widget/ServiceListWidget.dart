import 'package:autonomosapp/bloc/ServiceListWidgetBloc.dart';
import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/ui/widget/AbstractDataListWidget.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/SearchBarWidget.dart';


// ainda exista a falta de generalizacao, e tem 1 único armengue
//para permitir a seleção programaticamente do tipo de click!
enum ClickMode { TAP, SELECTION }

class ServiceListWidget extends StatefulWidget {
  final _itemSelectedCallback;
  final List<Service>_initialSelectedItems;
  final ClickMode _clickMode;
  final Function _singleClickCallback;

  ServiceListWidget( {

    void itemsSelectedCallback(List<Service> selectedItems),
    void singleClickCallback(Service item), // TAP mode
    List<Service> initialSelectedItems, ClickMode clickMode = ClickMode.SELECTION  } ) :
        _itemSelectedCallback = itemsSelectedCallback,
        _clickMode = clickMode,
        _singleClickCallback = singleClickCallback,
        _initialSelectedItems = initialSelectedItems;

  @override
  State createState () =>_ServiceListWidgetState();

}

class _ServiceListWidgetState extends State<ServiceListWidget> {
  ServiceListWidgetBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_bloc != null)
      _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("ServiceListWidgetState build()");

    _bloc = ServiceListWidgetBlocProvider.of(context);
    _bloc.loadServicesFromWeb();

    if ( ( widget._initialSelectedItems != null ) && (widget._clickMode == ClickMode.SELECTION)){
      _bloc.selectedItems.listen( (itemList) {
        widget._itemSelectedCallback(itemList);
      });

    }

    if( (widget._initialSelectedItems != null) && (widget._initialSelectedItems.isNotEmpty)){
      _bloc.selectItems(widget._initialSelectedItems);
      widget._initialSelectedItems.clear();
    }

    var searchBar = SearchBarWidget(
      hint: "Buscar serviços...",
      color: Colors.red[300],
      onTyped: (String data) {
        _bloc.searchFor( data );
        //print(data);
      },
    );

    return StreamBuilder< List<Service> >(
      stream: _bloc.getAllServices,
      builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {

        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Column(
              children: <Widget>[
                searchBar,
                CircularProgressIndicator(
                  semanticsLabel: "Carregando...",
                ),

              ],
            );

          case ConnectionState.active:
          case ConnectionState.done:
            return Column(
              children: <Widget>[
                searchBar,
                ListWidget(
                    snapshot.data,
                    singleClickCallback: widget._singleClickCallback,
                    clickMode: widget._clickMode,
                ),
              ],
            );
          case ConnectionState.none:
            return Text("NO CONNECTION!!!");
        }
      },
    );
  }
}

class ListWidget extends AbstractDataListWidget< Service > {
  final _clickMode;
  final Function _singleClickCallback;

  ListWidget(List<Service> list,{ ClickMode clickMode = ClickMode.SELECTION,
    void singleClickCallback(Service item)  }) :
  _clickMode = clickMode,
  _singleClickCallback = singleClickCallback,
  super( itemList: list );

  @override
  Widget onCreateWidget(Service data, int index) {
    return ServiceItemView(
      item: data,
      defaultColor: Colors.white,
      selectedColor: Colors.green,
      clickMode: _clickMode,
      singleClickCallback: _singleClickCallback,
    );
  }
}
//
// essa a classe que deve ser generica
class ServiceItemView extends StatefulWidget implements Comparable<ServiceItemView> {
  final Service item;
  final _clickMode;
  final Function _singleClickCallback;

  ServiceItemView( {@required Service item,
    Color defaultColor = Colors.white,
    Color selectedColor = Colors.green,
    ClickMode clickMode = ClickMode.SELECTION,
    void singleClickCallback(Service item)  } ) :
        this.item = item,
        this._singleClickCallback = singleClickCallback,
        this._clickMode = clickMode;

  @override
  State createState() => _ServiceItemViewState();

  @override
  int compareTo(ServiceItemView other) {
    return this.item.id.toString().compareTo( other.item.id.toString() );
  }
}

class _ServiceItemViewState extends State<ServiceItemView> {

  ServiceListWidgetBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print("_CityItemViewState build()");
    if (_bloc == null)
      _bloc = ServiceListWidgetBlocProvider.of(context);

    return
      Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Card(
          color: (_bloc.isSelected( widget.item)) ? Colors.green[300] : Colors.white,
          child: ListTile(
            title: Text( "${widget.item.name}", style: TextStyle(fontSize: 20.0)),
            leading: Icon(Icons.room_service),
            onTap: (){
              if ( (widget._clickMode == ClickMode.TAP) &&
                ( widget._singleClickCallback != null) ) {
                widget._singleClickCallback(widget.item);
              }

              else {
                if (_bloc.isSelected( widget.item ) )
                  _bloc.removeItem( widget.item );
                else _bloc.selectItem( widget.item );
                setState(() {});
              }

            },
          ),
        ),
      );
  }
}