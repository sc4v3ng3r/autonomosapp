import 'package:autonos_app/model/Service.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/bloc/ServiceBloc.dart';
import 'package:autonos_app/ui/widget/SearchBarWidget.dart';
import 'package:autonos_app/ui/widget/ServicesListWidget.dart';


//TODO tratar os toques de seleção no serviço
class ClientChooseServicesFragment extends StatefulWidget {
  @override
  State createState() => _ClientChooseServicesFragmentState();
}

class _ClientChooseServicesFragmentState extends State<ClientChooseServicesFragment> {
  ServiceBlock bloc = new ServiceBlock();
  List<Service> _servicos;
  List<Service> _searchItens = [];

  @override
  void initState() {
    super.initState();
    bloc.getServices();
  }

  TextEditingController controller = new TextEditingController();

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

  Widget _listaServicos(AsyncSnapshot<List<Service>> snapshot) {
    _servicos = snapshot.data;
    return ServicesListWidget(_servicos,);
  }

  Widget _listaServicosProcurados(AsyncSnapshot<List<Service>> snapshot) {
    _servicos = snapshot.data;
    return ServicesListWidget( _searchItens, );
  }

  Widget _loading() {
    return Column(
      children: <Widget>[
        SearchBarWidget(onTyped: null, color: Colors.red[300], ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text("Loading..."),
            ),
          ],
        ),
      ],
    );
  }

  Widget _servicosAtuais(AsyncSnapshot<List<Service>> snapshot) {
    if (_searchItens.length != 0 || controller.text.isNotEmpty)
      return _listaServicosProcurados(snapshot);
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
            return _loading();

          case ConnectionState.active:

          case ConnectionState.done:
            print("BUILDER DONE!");
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
