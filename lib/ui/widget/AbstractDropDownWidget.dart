import 'package:flutter/material.dart';

abstract class AbstractDropDownWidget<T> extends StatefulWidget {
  final String _title;
  final List<T> _items;
  final T _initialValue;
  final Function _onItemSelected;

  AbstractDropDownWidget({
    @required List<T> items,
    @required onItemSelected(T item),
    String title = "",
    T initialValue }) : _onItemSelected = onItemSelected,
        _items = items,
        _initialValue = initialValue,
        _title = title;

  Widget createItemLayout(T item);

  @override
  _AbstractDropDownWidgetState createState() => _AbstractDropDownWidgetState();

}

class _AbstractDropDownWidgetState<T> extends State<AbstractDropDownWidget>{
  List<DropdownMenuItem<T>> _itemList;
  T _currentValue;

  @override
  void initState() {
    super.initState();
    _itemList = _createMenuItemList();
    _currentValue = widget._initialValue;
  }

  @override
  Widget build(BuildContext context) {

    return DropdownButton<T>(
      hint: Text(widget._title),
      value: _currentValue,
      items: _itemList,
      onChanged: (T item) {
        _changeValue(item);
        if (widget._onItemSelected != null)
          widget._onItemSelected(item);
      },

    );
  }

  List<DropdownMenuItem<T>> _createMenuItemList(){
    List<DropdownMenuItem<T>> itemList = List();

    for(T item in widget._items){
      var menuItem = DropdownMenuItem<T>(
        child: widget.createItemLayout(item),
        value: item,
      );

      itemList.add(menuItem);
    }

    return itemList;
  }

  _changeValue(T value){
    setState(() {
      _currentValue = value;
    });
  }
}