import 'package:autonomosapp/model/Cidade.dart';
import 'package:autonomosapp/model/Estado.dart';
import 'package:autonomosapp/ui/widget/CityListWidget.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/bloc/CityListWidgetBloc.dart';

class ListagemCidades extends StatefulWidget {
  final Estado _estado;
  final List<Cidade> _alreadySelectedCities; // cidades já selecionadas anteriormente...

  ListagemCidades(
      {@required Estado estado, List<Cidade> alreadySelectedCities } ) :
        this._estado = estado,
        this._alreadySelectedCities = alreadySelectedCities;

  @override
  ListagemCidadesState createState() => ListagemCidadesState();
}

class ListagemCidadesState extends State<ListagemCidades> {

  List<Cidade> _cidadesSelecionadas;
  var _body;

  @override
  void initState() {
    super.initState();
    _cidadesSelecionadas = new List();
    _body = CityListWidgetBlocProvider(
        child: CityListWidget(
          sigla: widget._estado.sigla,
          initialSelectedItems: widget._alreadySelectedCities,
          itemsSelectedCallback: (List<Cidade> items) {
            _cidadesSelecionadas.clear();
            _cidadesSelecionadas.addAll( items );
          },
        )
    );

  }


  Widget _confirmButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        SnackBar(content: Text('abc'));
        Navigator.of(context).pop(_cidadesSelecionadas);
      },
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[ _confirmButton(context), ],
        elevation: 0.0,
        backgroundColor: Colors.red[300],
        title: Text( '${this.widget._estado.nome}',  style: TextStyle(color: Colors.white),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop( _cidadesSelecionadas );
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

}

