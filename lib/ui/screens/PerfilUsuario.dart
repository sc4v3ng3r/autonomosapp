import 'package:autonos_app/bloc/ProfessionalRegisterFlowBloc.dart';
import 'package:autonos_app/firebase/FirebaseServicesHelper.dart';
import 'package:autonos_app/firebase/FirebaseUserHelper.dart';
import 'package:autonos_app/model/Service.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/ProfessionalRegisterLocationAndServiceScreen.dart';
import 'package:autonos_app/ui/widget/AccountDetailsLayout.dart';
import 'package:autonos_app/ui/widget/ModalRoundedProgressBar.dart';
import 'package:autonos_app/ui/widget/MyDivisorLayout.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:autonos_app/ui/widget/ServiceListProfissionalWidget.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PerfilUsuario extends StatefulWidget {
  @override
  PerfilUsuarioState createState() => PerfilUsuarioState();
}

class PerfilUsuarioState extends State<PerfilUsuario> {
  static double _nota = 4.3;
  User user;
  FirebaseServicesHelper servicesHelper;
  String name = '';
  ProgressBarHandler _progressBarHandler;
  ProfessionalRegisterFlowBloc _bloc;

  double ratingUser = .0;

  final SizedBox _VERTICAL_SEPARATOR = SizedBox(
    height: 16.0,
  );
  RatingBar ratingBar;
  MyDivisor myDivisor;


  @override
  void initState() {
    _progressBarHandler = new ProgressBarHandler();
    _bloc = new ProfessionalRegisterFlowBloc();
    _getUser();
    myDivisor = new MyDivisor();
    _createListService();
    super.initState();
  }

  static Widget chipCidade(String nomeItem){
    return Chip(
      label: Text(nomeItem),
      padding: EdgeInsets.all(4.0),
      backgroundColor: Colors.red[300],
      labelStyle: TextStyle(color: Colors.white),
    );
  }
  static Widget chipServico(String nomeItem){
    return Chip(
      label: Text(nomeItem),
      padding: EdgeInsets.all(4.0),
      backgroundColor: Colors.blueGrey[300],
      labelStyle: TextStyle(color: Colors.white),
    );
  }


  void _getUser() async{
    user = await FirebaseUserHelper.currentLoggedUser();
    if(user!=null){
      if(user.professionalData != null){
        print('É UM PROFISSIONAL');
      }else{
        print('NÃO É UM PROFISSIONAL');
      }
//     _progressBarHandler.dismiss();
      name = user.name;
      ratingUser = user.rating;
      ratingBar = new RatingBar(rating: ratingUser);
      print('User Não NULO, Nome = $name');
    }else{
      print('User NULO');
    }
  }
//  Future<Widget> _selectHomeScreen() async {
//    User user = await FirebaseUserHelper.currentLoggedUser();
//    if (user == null )
//      return LoginScreen();
//
//    UserRepository().currentUser = user;
//    return MainScreen();
//  }
  List<Widget> servicoList = new List();
//  [
//    chipServico('Pedreiro'),
//    chipServico('Padeiro'),
//    chipServico('Coatureira'),
//    chipServico('Eletricista'),
//    chipServico('Caseiro'),
//    chipServico('Jardineiro'),
//    Text('Pedreiro'),
//    Text('Padeiro'),
//    Text('Coatureira'),
//    Text('Eletricista'),
//    Text('Caseiro'),
//    Text('Jardineiro'),
//  ];
  List<Widget> cidadesList = new List();

  Future<String> _getNomeServivos(String servico) async{
    DataSnapshot firebase = await FirebaseDatabase.instance.reference().child('servicos').child(servico).child('name').once();
    print('VALOR DA LISTA:'+firebase.value.toString());
    setState(() {
      servicoList.add(chipServico(firebase.value.toString()));
    });
  }
  void _createListService() async{
    List<String> servicosUser = user.professionalData.servicosAtuantes;
    print(user.professionalData.servicosAtuantes.toString());

    for(String servico in servicosUser){
      _getNomeServivos(servico);
//      servicoList.add(chipServico(servico));
    }
  }
  Widget _servicos(){
    if(servicoList.length == 0)
      _createListService();

    return Container(
      padding: EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 4.0,
          children: servicoList
        ),
    );
  }

  Widget _cidades(){
    List<String> cidadesUser = user.professionalData.cidadesAtuantes;
    if(cidadesList.length == 0 )
    for(String cidade in cidadesUser){
      cidadesList.add(chipCidade(cidade));
    }

    return Padding(
      padding: EdgeInsets.all(12.0),

          child: Wrap(
            spacing: 4.0,
            children: cidadesList,
          ),
//      ),
    );
  }
  List<Widget> _buildForm() {
    final nome = Expanded(
      child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              '$name',
              style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),
            ),
          ),
        ],
      ),
    );

    final email = Padding(
      padding: EdgeInsets.fromLTRB(.0, 16.0, .0, .0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              user.email,
              style: TextStyle(color: Colors.blueGrey, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );

    final telefone = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(
            user.professionalData.telefone,
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
      ],
    );

    final foto = Padding(
      padding: EdgeInsets.fromLTRB(.0, .0, 16.0, .0),
      child: Container(
        height: 64.0,
        width: 64.0,
        child: CircleAvatar(
          backgroundColor: Colors.green[300],
          //backgroundImage: AssetImage('assets/usuario.png'),
        ),
      ),
    );

    final rating = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ratingBar,
        Text(
          '($ratingUser)',
          style: TextStyle(color: Colors.blueGrey),
        ),
      ],
    );

    final InformacoesBasicas = Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, .0),
        child: Row(
          children: <Widget>[foto, nome],
        )
    );
    final emailTelRatingGroup = Column(
      children: <Widget>[rating, email, telefone],
    );

    final _editingPerfilText1 = Text(
        'Precisa editar as cidades ou serviços?',
      style: TextStyle(color: Colors.grey[500],fontSize: 12.0),
    );
//    final _textEditing2 = TextB(
//        'Clique aqui',
//    );
    final _editingPerfilText2 = Flexible(
      child: FlatButton(onPressed:
          (){
            _bloc.insertBasicProfessionalInformation(
                typePeople: null,
                documentNumber: null,
                phone: null,
                description: null);
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context)=>
                    ProfessionalRegisterLocationAndServiceScreen(
                      bloc: _bloc,
                    ))
                );
          },
          padding: EdgeInsets.fromLTRB(.0, .0, 16.0, .0),
          child: Text('Clique aqui.',style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),)),
    );

    final _editingPerfilTextGroup = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _editingPerfilText1,
        _editingPerfilText2
      ],
    );
    final form = Form(
      child: ListView(
        children: <Widget>[
          InformacoesBasicas,
          emailTelRatingGroup,
          _VERTICAL_SEPARATOR,
          myDivisor.divisorGroup('Cidades'),
          _cidades(),
          myDivisor.divisorGroup('Serviços'),
          ServiceListProfissionalWidget(serviceList: servicoList, user: user),
          _editingPerfilTextGroup
//          _textEditingCidadePt1
        ],
      ),
    );


    List<Widget> list = new List();
    list.add(form);
    return list;
  }

  Scaffold _showScreen(){
//    _progressBarHandler.show();
    return Scaffold(
        body: Center(
          child: Stack(
            children: _buildForm(),
          ),
        ));
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var modal = ModalRoundedProgressBar(
        handleCallback: (handler){
          _progressBarHandler = handler;
        });

    return FutureBuilder<User>(

      future: FirebaseUserHelper.currentLoggedUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch ( snapshot.connectionState ) {
          case ConnectionState.none:
//            return _progressBarHandler.show();
          case ConnectionState.active:
//            return _progressBarHandler.show();
          case ConnectionState.waiting:
            print("STATE ${snapshot.connectionState.toString()}");
            return Stack();

        //TODO MELHORAR ESSA VERIFICACAO!
          case ConnectionState.done:
            print("STATE ${snapshot.connectionState.toString()}");
            print("Snapshot:  ${snapshot.data} ");

            if (snapshot.data != null){
              UserRepository().currentUser = snapshot.data;
              return Stack(
                children: <Widget>[
                  _showScreen(),
                  modal
                ],
              );
            }
        }
      },
    );
  }
}
