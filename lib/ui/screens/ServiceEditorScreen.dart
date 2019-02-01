import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/bloc/ServiceListWidgetBloc.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/ui/widget/ServiceListWidget.dart';
import 'package:autonomosapp/ui/widget/ModalRoundedProgressBar.dart';
import 'package:autonomosapp/firebase/FirebaseUfCidadesServicosProfissionaisHelper.dart';

/// Screen para edição de serviços prestados por um profissional.
///
class ServiceEditorScreen extends StatefulWidget {
  final _currentUserServices;

  ServiceEditorScreen({@required List<Service> currentServicesList})
    : _currentUserServices = currentServicesList;

  @override
  State<StatefulWidget> createState() => _ServiceEditorScreenState();
}

class _ServiceEditorScreenState extends State<ServiceEditorScreen>{

  List<Service> _selectedServices;
  var _body;
  ProgressBarHandler _handler;
  @override
  void initState() {
    super.initState();
    _selectedServices = List.from( widget._currentUserServices );
    _body = Stack(
      children: <Widget>[
        ServiceListWidgetBlocProvider(
          child: ServiceListWidget(
            initialSelectedItems: _selectedServices,
            itemsSelectedCallback: (serviceList) {
              //print("Total SERVICE data selected ${serviceList.length}");
              _selectedServices = serviceList;
            } ,
          ),
        ),
        ModalRoundedProgressBar(handleCallback: (handler){_handler = handler;}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("statefull builder");

    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Serviços Atuantes"),
        elevation: .0,
        backgroundColor: Colors.red[300],
      ),

      body: _body,

      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.done , color: Colors.white,),
          onPressed: _saveData),
    );
  }

  void _saveData(){
    _handler.show(message: "Registrando...");
    print("TOTAL SERVICOS SELECIONADOS: ${_selectedServices.length}");
    User user =UserRepository().currentUser;
    user.professionalData.servicosAtuantes.clear();

    List<Service> servicesToRemove = List.from(widget._currentUserServices);

    for (Service srv in _selectedServices){
      user.professionalData.servicosAtuantes.add( srv.id );
      servicesToRemove.remove( srv );
    }

    for(Service s in servicesToRemove){
      print("will be removed ${s.name}");
    }

    FirebaseUfCidadesServicosProfissionaisHelper.removeServicesFromProfessionalUser(
        servicesToRemove , user.professionalData);
    FirebaseUserHelper.registerUserProfessionalData(user.professionalData);

    _handler.dismiss();
    Navigator.pop(context);
  }

}
