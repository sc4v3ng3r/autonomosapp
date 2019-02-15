import 'package:autonomosapp/model/Cidade.dart';
import 'package:autonomosapp/model/Estado.dart';
import 'package:autonomosapp/ui/widget/CityListWidget.dart';
import 'package:autonomosapp/utility/Constants.dart';
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("${widget._estado.nome}"),
        brightness: Brightness.dark,
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: Constants.TOOLTIP_CONFIRM,
        onPressed: () {
          Navigator.of(context).pop( _cidadesSelecionadas );
        },

        elevation: 8.0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon( Icons.check, color: Theme.of(context).accentColor,),
      ),

      body: _body,
    );
  }

}

