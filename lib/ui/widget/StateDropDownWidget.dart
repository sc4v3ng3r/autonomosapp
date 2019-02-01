import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/AbstractDropDownWidget.dart';

class StateDropDownWidget extends AbstractDropDownWidget<String> {

  StateDropDownWidget({
    @required List<String> items,
    @required onItemSelected(String item),
    String title = "",
    String initialValue }) :
        super( items : items, onItemSelected : onItemSelected,
        initialValue : initialValue, title : title);

  @override
  Widget createItemLayout(String item) {
    return Text(item);
  }
}