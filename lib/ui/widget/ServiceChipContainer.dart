import 'package:flutter/material.dart';
import 'package:autonos_app/ui/widget/AbstractChipContainerWidget.dart';
import 'package:autonos_app/model/Service.dart';

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