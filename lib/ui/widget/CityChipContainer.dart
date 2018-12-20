import 'package:flutter/material.dart';
import 'package:autonos_app/ui/widget/AbstractChipContainerWidget.dart';
import 'package:autonos_app/model/Cidade.dart';

class CityChipContainer extends AbstractChipContainerWidget<Cidade> {

  CityChipContainer( {
    @required Function onDelete(Cidade item),
    @required Function controllerCallback(ChipContainerController controller) } ) :
        super(
          onDelete: onDelete,
          controllerCallback : controllerCallback,
          chipBackgroundColor: Colors.red[300]
      );

  @override
  Widget chipLabel(Cidade element) {
    return Text(
        "${element.nome}",
        style: TextStyle(color: Colors.white),
    );
  }
}