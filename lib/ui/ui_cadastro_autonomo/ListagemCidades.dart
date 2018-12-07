import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/model/Estado.dart';
import 'package:autonos_app/ui/widget/CityListWidget.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/bloc/CityListWidgetBloc.dart';

class ListagemCidades extends StatefulWidget {
  final List<String> _cidadesConfirmadas;
  final Estado _estado;

  ListagemCidades(
      { List cidadesConfirmadas, @required Estado estado } )
      : this._cidadesConfirmadas = cidadesConfirmadas,
        this._estado = estado;

  @override
  ListagemCidadesState createState() =>
      ListagemCidadesState();
}

class ListagemCidadesState extends State<ListagemCidades> {

  List<String> _cidadesSelecionadas;
  var _body;
  // vou precisar para escutar a streaming de Cidades selecinados
  //final CityListWidgetBloc _bloc = CityListWidgetBloc();

  @override
  void initState() {
    _cidadesSelecionadas = new List();
    _body = CityListWidgetBlocProvider(
        child: CityListWidget(
          sigla: widget._estado.sigla,
          itemsSelected: (List<Cidade> items) {
            _cidadesSelecionadas.clear();

            items.forEach( (cidade) {
              _cidadesSelecionadas.add( cidade.nome );
            });
          },
        )
    );
    super.initState();
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

