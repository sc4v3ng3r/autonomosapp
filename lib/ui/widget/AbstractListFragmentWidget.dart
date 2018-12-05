import 'package:flutter/material.dart';

abstract class AbstractListFragmentWidget<T extends Comparable<T>>
    extends StatefulWidget {
  final List<T> _itemList;
  final Function _onSearch;


  AbstractListFragmentWidget(List<T> itemList,
      {Function onSearch}) :
        _itemList = itemList,
        _onSearch = onSearch;

  @override
  State createState() {
    return _AbstractListFragmentWidgetState<T>();
  }

  Widget onCreateWidget(T data, int index);

}

class _AbstractListFragmentWidgetState<T extends Comparable<T> >
    extends State<AbstractListFragmentWidget> {

  List<T> _searchItens = [];
  List<T>_selectedItens= [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget._itemList.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.onCreateWidget(widget._itemList[index], index);
        },
      ),
    );
  }
} //end of class
