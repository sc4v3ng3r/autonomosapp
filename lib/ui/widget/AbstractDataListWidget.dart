import 'package:flutter/material.dart';

enum AbstractDataListWidgetSelectionMode { MULTIPLE_CHOICE, SINGLE_CHOICE }

abstract class AbstractDataListWidget<T extends Comparable<T>>
    extends StatefulWidget {

  final List<T> _itemList;
  //final _disposeCallback;

  AbstractDataListWidget({List<T> itemList /*, void dispose() */})
      : _itemList = itemList;
       /* _disposeCallback = dispose;*/

  @override
  State createState() {
    return _AbstractDataListWidgetState<T>();
  }
  // metodo que a gente vai implementar para poder desenhar o a widget como a gente quer!!
  Widget onCreateWidget(T data, int index);
}

class _AbstractDataListWidgetState<T extends Comparable<T>>
    extends State<AbstractDataListWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("_AbstractDataListWidgetState build()");
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10.0),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget._itemList.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.onCreateWidget(widget._itemList[index], index);
        },
      ),
    );
  }

  @override
  void dispose() {
    print("_AbstractDataListWidgetState dispose()");
    super.dispose();
  }
} //end of class
