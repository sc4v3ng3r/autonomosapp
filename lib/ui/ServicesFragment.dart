import 'package:flutter/material.dart';
import 'package:autonos_app/bloc/ServiceBloc.dart';

class ServicesFragment extends StatefulWidget {

  @override
  State createState() => _ServicesFragmentState();
}

class _ServicesFragmentState extends State<ServicesFragment> {
  ServiceBlock bloc = new ServiceBlock();

  @override
  void initState() {
    super.initState();
    bloc.getServices();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder< List<String> > (
      stream: bloc.allServices,
      builder: ( BuildContext context, AsyncSnapshot< List< String> > snapshot ) {
        switch( snapshot.connectionState ) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          print("BLOC CONNECTION ${snapshot.connectionState}");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text("Loading..."),
              ),
            ],
          );

          case ConnectionState.active:

          case ConnectionState.done:
            return ListView.builder(itemBuilder: (BuildContext context, int index) {
              Text serviceText = Text('${snapshot.data[index]}', style: TextStyle(fontSize: 20.0));
              ListTile tile = ListTile(
                title: serviceText,
                leading: Icon( Icons.room_service),
                onTap: () {
                    // TODO AQUI VAMOS ABRIR A TELA DE MAPA, ANTES REALIZANDO A BUSCA POR
                    // PROFISSIONAIS NUMA DETERMINADA ÁREA QUE REALIZAM O SERVICO CLICADO!
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("${serviceText.data} index: $index"),
                        backgroundColor: Colors.redAccent,),
                    );
                  },
              );

              return Card(
                child: tile,
              );
            },

            itemCount: snapshot.data.length,
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