import 'package:flutter/material.dart';

class GenericDataListScreen<T> extends StatefulWidget {
  List<T> dataList;
  String _title;
  GenericDataListScreen(/*this.dataList, */@required this._title);

  @override
  State createState( ) {
    return _GenericDataListState();
  }
}

class _GenericDataListState extends State<GenericDataListScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        backgroundColor: Colors.red[300],
        elevation: 0,
        actions: <Widget>[],
      ),

      body: _createLayout(),
    );
  }

  Widget _createLayout(){
    var searchBar = Column(

      children: <Widget>[
        Container(
          color: Colors.red[300],
          child: Padding(
            padding: EdgeInsets.all(.0),
            child: Card(
              elevation: 8.0,
              color: Colors.white,
              child: ListTile(

                leading: Icon(
                  Icons.search,
                  color: Colors.red[400],
                ),

                title: TextField(
                  //onChanged: _onBuscaItem,
                  //controller: controller,
                  decoration: new InputDecoration(
                      border: InputBorder.none, hintText: 'Busca'),
                ),

                trailing: new IconButton(
                    icon: Icon(Icons.cancel, color: Colors.black87),
                    onPressed: () {
                      //controller.clear();
                      //_onBuscaItem('');
                    }),
              ),
            ),
          ),
        ),
      ],
    );


    return searchBar;
  }
}