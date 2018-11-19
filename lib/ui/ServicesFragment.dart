import 'package:flutter/material.dart';
import 'package:autonos_app/firebase/FirebaseServicesHelper.dart';
import 'package:autonos_app/firebase/FirebaseReferences.dart';
import 'package:autonos_app/bloc/ServiceBloc.dart';

class ServicesFragment extends StatefulWidget {


  @override
  State createState() => _ServicesFragmentState();
}

class _ServicesFragmentState extends State<ServicesFragment> {
  ServiceBlock bloc = new ServiceBlock();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getServices();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder< List<String> >(
      stream: bloc.allServices,

      builder: ( BuildContext context, AsyncSnapshot< List<String> > snapshot ) {
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
            print("BLOC CONNECTION DONE!");
            return ListView(
                shrinkWrap: true,
                children: _generateListItens( snapshot.data  ),
            );
            break;
        }
      },
    );
  }

  List<Card> _generateListItens(List<String> services){
    List<Card> list = List();
    for(int i=0; i < services.length; i++){
      list.add(
        Card(
          child:
          ListTile(
            title: Text('${services[i]}', style: TextStyle(fontSize: 20.0), ),
            leading: Icon( Icons.room_service),
            onTap: () =>  print('clicked item') ,
          ),
        ),
      );
    }
    return list;
  }

  @override
  void dispose() {
    bloc.dispose();
    print("ServiceFragment::Dispose");
    super.dispose();
  }

}