import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/AbstractChipContainerWidget.dart';
import 'package:autonomosapp/model/Cidade.dart';

class CityChipContainer extends AbstractChipContainerWidget<Cidade> {
  final Color _textColor;
  CityChipContainer( {
    @required Function onDelete(Cidade item),
    @required Function controllerCallback(ChipContainerController controller),
    @required textColor, Color deleteButtonColor, Color backgroundColor } ) :
      _textColor = textColor,
        super(
          onDelete: onDelete,
          deleteButtonColor : deleteButtonColor,
          controllerCallback : controllerCallback,
          backgroundColor: backgroundColor,
      );

  @override
  Widget chipLabel(Cidade element) {
    return Text(
        "${element.nome}",
        style: TextStyle(color: _textColor),
    );
  }
}