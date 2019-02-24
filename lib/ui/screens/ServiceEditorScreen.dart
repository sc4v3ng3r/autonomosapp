import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/bloc/ServiceListWidgetBloc.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/utility/Constants.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Editar Serviços Atuantes"),
        elevation: .0,
        brightness: Brightness.dark,
      ),

      body: _body,

      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          tooltip: Constants.TOOLTIP_CONFIRM,
          child: Icon(
            Icons.done,
            color: Theme.of(context).accentColor
          ),
          onPressed: (){
            if (_validate())
              _saveData();
            else {
              _scaffoldKey.currentState
                  .showSnackBar(
                  SnackBar(
                    duration: Duration(milliseconds: 1900),
                    backgroundColor: Theme.of(context).errorColor,
                    content: Text("Selecione pelo menos um serviço",
                      style: TextStyle( color: Colors.white ),
                    ),
                  ),
              );
            }
          }),
    );
  }

  void _saveData(){
    _handler.show(message: "Registrando...");
    print("TOTAL SERVICOS SELECIONADOS: ${_selectedServices.length}");
    User user =UserRepository.instance.currentUser;
    user.professionalData.servicosAtuantes.clear();

    List<Service> servicesToRemove = List.from(widget._currentUserServices);

    for (Service srv in _selectedServices){
      user.professionalData.servicosAtuantes.add( srv.id );
      servicesToRemove.remove( srv );
    }

    FirebaseUfCidadesServicosProfissionaisHelper.removeServicesFromProfessionalUser(
      user.uid, servicesToRemove , user.professionalData);
    FirebaseUserHelper.setUserProfessionalData(
      data: user.professionalData,
      uid: user.uid,
    );

    _handler.dismiss();
    Navigator.pop(context);
  }

  bool _validate() => _selectedServices.isNotEmpty;
}
