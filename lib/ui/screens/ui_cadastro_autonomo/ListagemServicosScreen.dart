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
    super.initState();
  }


  Widget _confirmButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        SnackBar(content: Text('abc'));
        Navigator.of(context).pop(_servicesSelected);
      },
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
//
  Widget _iconButton(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          _voltarDialog(context);
        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[ _confirmButton(context), ],
        elevation: 0.0,
        backgroundColor: Colors.red[300],
        title: Text( 'Serviços',  style: TextStyle(color: Colors.white),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop( _servicesSelected );
        },

        foregroundColor: Colors.red,
        elevation: 8.0,
        backgroundColor: Colors.red[300],
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),

      body: _body,
    );
  }

  // está funcionando???
  AlertDialog _voltarDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Alerta!'),
      content: Text('Tem certeza que você deseja voltar?'),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'))
      ],
    );
  }
}