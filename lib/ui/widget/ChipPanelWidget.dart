import 'package:autonos_app/model/Service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ChipPanelWidget<T> extends StatefulWidget {

  final Function _onEditClicked;
  final String _title;
  final List<String> _data;
  final Observable<List<T>> _dataStream;

  ChipPanelWidget( { @required String title,
    Function onEditCallback(List<T> data),
    List<String> data,
    Observable<List<T>> dataStream} )
      : _title = title,
        _onEditClicked = onEditCallback,
        _data = data,
        _dataStream = dataStream;

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
    //var divisor = _createDivisor(widget._title);

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
      chipList.add( Chip(label: Text(data)) );

    return _getChipContainer(chipList);
  }

  Widget _createDivisor(String text){
    final leftLine = Expanded(
      child:Container(
        color: Colors.grey[300],
        height: 1.0,
        margin: EdgeInsets.only(right: 8.0),
      ),
    );

    final rightLine = Expanded(
      child: Container(
        color: Colors.grey[300],
        height: 1.0,
        margin: EdgeInsets.only(left: 8.0),
      ),
    );

    return Row(
      children: <Widget>[
        leftLine,
        Text(text),
        rightLine,
      ],
    );
  }

  Widget _getChipContainer(List<Widget> widgetList){

    return Column(
      children: <Widget>[
        _createDivisor(widget._title),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              child: Icon(Icons.edit, color: Colors.blue,),
              onTap: (){
                print("chip panel callback");
                if (widget._onEditClicked != null){
                  var emits;
                  if (widget._data == null)
                    emits =_dataList;
                  else emits = widget._data;
                  widget._onEditClicked( emits );
                }
              },
            ),
          ],
        ),
        Wrap( children: widgetList, spacing: 2.0, ),
      ],
    );
  }
}
