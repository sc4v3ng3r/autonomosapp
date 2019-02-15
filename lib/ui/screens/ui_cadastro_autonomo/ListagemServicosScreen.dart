import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/ui/widget/ServiceListWidget.dart';
import 'package:autonomosapp/bloc/ServiceListWidgetBloc.dart';

class ListagemServicos extends StatefulWidget {
  final List<Service> _alreadySelectedServices; // cidades já selecionadas anteriormente...

  ListagemServicos(
      {List<Service> alreadySelectedServices } ) :
        this._alreadySelectedServices = alreadySelectedServices;

  @override
  ListagemServicosState createState() => ListagemServicosState();
}

class ListagemServicosState extends State<ListagemServicos> {

  List<Service> _servicesSelected;
  var _body;

  @override
  void initState() {
    super.initState();
    _servicesSelected = new List();
    _body = ServiceListWidgetBlocProvider(
        child: ServiceListWidget(
          initialSelectedItems: widget._alreadySelectedServices,
          itemsSelectedCallback: (List<Service> items) {
            _servicesSelected.clear();
            _servicesSelected.addAll( items );
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Serviços'),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: Constants.TOOLTIP_CONFIRM,
        onPressed: () {
          Navigator.of(context).pop( _servicesSelected );
        },
        elevation: 8.0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon( Icons.check, color: Theme.of(context).accentColor,),
      ),

      body: _body,
    );
  }

}