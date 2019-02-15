import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/AbstractChipContainerWidget.dart';
import 'package:autonomosapp/model/Service.dart';

class ServiceChipContainer extends AbstractChipContainerWidget<Service>{

  final Color _textColor;

  ServiceChipContainer( {

    @required Function onDelete(Service item),
    @required Function controllerCallback(ChipContainerController controller),
    Color backgroundColor,@required Color textColor, Color deleteButtonColor } ) :
      _textColor = textColor,

        super( onDelete: onDelete, deleteButtonColor : deleteButtonColor,
        controllerCallback : controllerCallback,
        backgroundColor: backgroundColor );

  @override
  Widget chipLabel(Service element) {
    return  Text(
      "${element.name}",
      style: TextStyle(
        color: _textColor
      ),

    );
  }
}