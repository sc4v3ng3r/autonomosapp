
import 'package:autonos_app/ui/widget/AbstractDataListWidget.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/model/Service.dart';

class ServicesListWidget extends AbstractDataListWidget<Service>{

  ServicesListWidget( List<Service> list) :
        super(
          itemList: list,);

  @override
  Widget onCreateWidget(data, int index) {

    Text serviceText = Text(data.name, style: TextStyle(fontSize: 20.0));

    return Card(
      elevation: 5.0,
      child: ListTile(
        title: serviceText,
        leading: Icon(Icons.room_service),
      ),
    );
  }
}