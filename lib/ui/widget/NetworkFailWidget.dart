import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';

class NetworkFailWidget extends StatelessWidget {

  final Function _callback;
  final String _title;
  final String _subTitle;
  final bool _refreshAction;

  static const String DEFAULT_TITLE = "Falha de conexão";
  static const String DEFAULT_SUBTITLE = "Não foi possível obter dados do servidor. "
      "Verifique sua conexão com a internet.";

  NetworkFailWidget({String title = DEFAULT_TITLE  ,String subtitle = DEFAULT_SUBTITLE,
    bool refreshAction = false, Function callback}) :
    _title = title,
    _refreshAction = refreshAction,
    _subTitle = subtitle,
    _callback = callback;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List();

    //Error Icon
    widgets.add(
      IconButton(
        onPressed: null,
        iconSize: 120,
        icon: Icon(Icons.error, color: Colors.red),
        color: Colors.blue,
      ),
    );

    // Title
    widgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child:Text(_title,
              maxLines: 2,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0
              ),
            ),
          ),

        ],
      ),
    );

    //subtitle
    widgets.add(
      Container(
        width: 220,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(_subTitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500]
                ),
              ),
            )
          ],
        ),
      ),
    );

    if (_refreshAction){
      widgets.add(Constants.VERTICAL_SEPARATOR_8);
      widgets.add(
        RaisedButton(
          color: Colors.green,
          onPressed: _callback,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.refresh, color: Colors.white,),
              Constants.HORIZONTAL_SEPARATOR_8,
              Text("Recarregar",
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          )
      );
    }


    return Column( children: widgets );
  }
}
