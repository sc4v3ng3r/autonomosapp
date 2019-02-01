import 'package:autonomosapp/model/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ServiceListProfissionalWidget extends StatefulWidget{
  final List<Widget> _serviceList;
  final User _user;
  ServiceListProfissionalWidget( {@required List<Widget> serviceList,@required User user})
      : _serviceList =serviceList, _user =user ;

  @override
  ServiceListProfissionalWidgetState createState() => ServiceListProfissionalWidgetState();
}

class ServiceListProfissionalWidgetState extends State<ServiceListProfissionalWidget>{

  Widget _chipServico(String nomeItem){
    return Chip(
      label: Text(nomeItem),
      padding: EdgeInsets.all(4.0),
      backgroundColor: Colors.blueGrey[300],
      labelStyle: TextStyle(color: Colors.white),
    );
  }

  Future<String> _getNomeServivos(String servico) async{
    DataSnapshot firebase = await FirebaseDatabase.instance.reference().child('servicos').child(servico).child('name').once();
    print('VALOR DA LISTA:'+firebase.value.toString());
    setState(() {
      widget._serviceList.add(_chipServico(firebase.value.toString()));
    });
  }
  void _createListService() async{
    List<String> servicosUser = widget._user.professionalData.servicosAtuantes;
    print(widget._user.professionalData.servicosAtuantes.toString());

    for(String servico in servicosUser){
      _getNomeServivos(servico);
//      servicoList.add(chipServico(servico));
    }
  }
  Widget _servicos(){
    if(widget._serviceList.length == 0)
      _createListService();

    return Container(
      padding: EdgeInsets.all(12.0),
      child: Wrap(
          spacing: 4.0,
          children: widget._serviceList
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _servicos();
  }

}