import 'package:autonomosapp/model/Service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:autonomosapp/ui/widget/NiftyRowDivisorWidget.dart';

class ChipPanelWidget<T> extends StatefulWidget {

  final Function _onEditClicked;
  final String _title;
  final List<String> _data;
  final Observable<List<T>> _dataStream;
  final Color _itemTextColor;
  final Color _iconColor;
  final bool _editable;

  ChipPanelWidget( { @required String title,
    Function onEditCallback(List<T> data),
    List<String> data,
    Observable<List<T>> dataStream,
    bool editable = false,
    Color itemTextColor = Colors.black,
    Color editIconColor = Colors.blue,
    } )
      : _title = title,
        _onEditClicked = onEditCallback,
        _data = data,
        _editable = editable,
        _dataStream = dataStream,
        _itemTextColor = itemTextColor,
        _iconColor = editIconColor;


  @override
  _ChipPanelWidgetState createState() => _ChipPanelWidgetState();
}

class _ChipPanelWidgetState extends State<ChipPanelWidget> {
  List<Service> _dataList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (widget._dataStream!=null){

      return StreamBuilder(
        stream: widget._dataStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          switch( snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return  CircularProgressIndicator();

            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData){
                List<Service> serviceList = List.from(snapshot.data);
                List<Widget> chipList = List();

                for(var service in serviceList)
                  chipList.add(  Chip(label: Text("${service.name}")) );

                _dataList = serviceList;
                return _getChipContainer( chipList );
              }
          }
        },
      );
    }
    print("ChipPanelWidget::builder normal strings!");
    List<Widget> chipList = List();

    for (String data in widget._data)
      chipList.add( Chip(
        label: Text(data,
          style: TextStyle( color: widget._itemTextColor),
        ),
      ) );

    return _getChipContainer(chipList);
  }

  Widget _getChipContainer(List<Widget> chipList){
    List<Widget> widgets = List();

    widgets.add( NiftyRowDivisorWidget(title: widget._title) );

    if (widget._editable){
      final editButton = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            child: Icon(Icons.edit, color: widget._iconColor,),
            onTap: _onEditCallbackCall,
          ),
        ],
      );
      widgets.add( editButton);
    }

    final wrapWidget = Wrap( children: chipList, spacing: 2.0, );
    widgets.add( wrapWidget);

    return Column( children: widgets, );
  }

  void _onEditCallbackCall(){
    if (widget._onEditClicked != null){
      var emits;
      if (widget._data == null)
        emits =_dataList;
      else emits = widget._data;
      widget._onEditClicked( emits );
    }
  }
}
