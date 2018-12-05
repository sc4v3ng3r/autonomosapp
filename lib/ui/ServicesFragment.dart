import 'package:autonos_app/model/Service.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/bloc/ServiceBloc.dart';
import 'package:autonos_app/ui/widget/SearchBarWidget.dart';

class ServicesFragment extends StatefulWidget {
  @override
  State createState() => _ServicesFragmentState();
}

class _ServicesFragmentState extends State<ServicesFragment> {
  ServiceBlock bloc = new ServiceBlock();
  List<Service> _servicos;

  @override
  void initState() {
    super.initState();
    bloc.getServices();
  }

  TextEditingController controller = new TextEditingController();
  List<Service> _searchItens = [];

  _onBuscaItem(String nome) async {
    _searchItens.clear();
    if (nome.isEmpty) {
      setState(() {});
      return;
    }
    _servicos.forEach((servico) {
      //se o nome do serviço conter qualquer parte do nome, adcione em searchItens
      if (servico.name.toLowerCase().contains(nome)) {
        _searchItens.add(servico);
      }
      setState(() {});
    });
  }

  /*
  Row _buscaFieldBar() {
    return Row(
      children: <Widget>[
        Flexible(
          child: Container(
            color: Colors.red[300],
            child: Padding(
              padding: EdgeInsets.all(.0),
              child: Card(
                elevation: 8.0,
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                  ),
                  title: TextField(
                    onChanged: _onBuscaItem,
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Busca',
                    ),
                  ),
                  trailing: new IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.blueGrey,
                      ),
                      onPressed: () {
                        controller.clear();
                        _onBuscaItem('');
                      }),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }*/

  Expanded _listaServicos(AsyncSnapshot<List<Service>> snapshot) {
    _servicos = snapshot.data;
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          Text serviceText = Text('${_servicos[index].name}',
              style: TextStyle(fontSize: 20.0)
          );
          ListTile tile = ListTile(
            title: serviceText,
            leading: Icon(Icons.room_service),
            onTap: () {
              // TODO AQUI VAMOS ABRIR A TELA DE MAPA, ANTES REALIZANDO A BUSCA POR
              // PROFISSIONAIS NUMA DETERMINADA ÁREA QUE REALIZAM O SERVICO CLICADO!

              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("${serviceText.data} index: $index"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
          );

          return Card(
            child: tile,
          );
        },
        itemCount: snapshot.data.length,
      ),
    );
  }

  Expanded _listaServicosProcurados(AsyncSnapshot<List<Service>> snapshot) {
    _servicos = snapshot.data;

    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          Text serviceText = Text('${_searchItens[index].name}',
              style: TextStyle(fontSize: 20.0));
          ListTile tile = ListTile(
            title: serviceText,
            leading: Icon(Icons.room_service),
            onTap: () {
              // TODO AQUI VAMOS ABRIR A TELA DE MAPA, ANTES REALIZANDO A BUSCA POR
              // PROFISSIONAIS NUMA DETERMINADA ÁREA QUE REALIZAM O SERVICO CLICADO!

              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("${serviceText.data} index: $index"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
          );

          return Card(
            child: tile,
          );
        },
        itemCount: _searchItens.length,
        padding: EdgeInsets.all(16.0),
      ),
    );
  }

  Column _carregando() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text("Loading..."),
        ),
      ],
    );
  }

  Expanded _servicosAtuais(AsyncSnapshot<List<Service>> snapshot) {
    if (_searchItens.length != 0 || controller.text.isNotEmpty) {
      return _listaServicosProcurados(snapshot);
    } else
      return _listaServicos(snapshot);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Service>>(
      stream: bloc.allServices,
      builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            print("BLOC CONNECTION ${snapshot.connectionState}");
            return _carregando();

          case ConnectionState.active:

          case ConnectionState.done:
            return Column(
              children: <Widget>[
                SearchBarWidget(
                  onTyped: (String data) {
                    _onBuscaItem(data);
                  },
                  color: Colors.red[300],
                ),
                _servicosAtuais(snapshot),
              ],
            );
            break;
        }
      },
    );
  }


  @override
  void dispose() {
    bloc.dispose();
    print("ServiceFragment::Dispose");
    super.dispose();
  }
}
