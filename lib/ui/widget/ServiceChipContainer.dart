import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/AbstractChipContainerWidget.dart';
import 'package:autonomosapp/model/Service.dart';

class ServiceChipContainer extends AbstractChipContainerWidget<Service>{

  ServiceChipContainer( {
    @required Function onDelete(Service item),
    @required Function controllerCallback(ChipContainerController controller) } ) :
      super( onDelete: onDelete,
        controllerCallback : controllerCallback,
        chipBackgroundColor: Colors.blueGrey );

  @override
  Widget chipLabel(Service element) {
    return  Text(
      "${element.name}",
      style: TextStyle(
        color: Colors.white
      ),

    );
  }
}