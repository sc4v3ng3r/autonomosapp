import 'package:autonos_app/model/User.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/bloc/ProfessionalRegisterFlowBloc.dart';
import 'package:autonos_app/ui/screens/ui_cadastro_autonomo/ProfessionalRegisterLocationAndServiceScreen.dart';
import 'package:autonos_app/ui/widget/ModalRoundedProgressBar.dart';
import 'package:autonos_app/ui/widget/MyDivisorLayout.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:autonos_app/ui/widget/ServiceListProfissionalWidget.dart';


class PerfilUsuarioProfissionalScreen extends StatefulWidget{
  final User _user;

  PerfilUsuarioProfissionalScreen({@required User user}): _user = user;

  @override
 PerfilUsuarioProfissionalScreenState createState() {
    return new PerfilUsuarioProfissionalScreenState();
  }
}

class PerfilUsuarioProfissionalScreenState extends State<PerfilUsuarioProfissionalScreen>{

  String name = '';
//  ProgressBarHandler _progressBarHandler;
  ProfessionalRegisterFlowBloc _bloc;

  List<Widget> servicoList = new List();
  List<Widget> cidadesList = new List();
  double ratingUser = .0;

  static const SizedBox _VERTICAL_SEPARATOR = SizedBox(
    height: 16.0,
  );
  RatingBar ratingBar;
  MyDivisor myDivisor;


  @override
  void initState() {
//    _progressBarHandler = new ProgressBarHandler();
    _bloc = new ProfessionalRegisterFlowBloc();
    myDivisor = new MyDivisor();
    ratingUser = widget._user.rating;
    ratingBar = new RatingBar(rating: ratingUser);
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


  Widget _cidades(){
    List<String> cidadesUser = widget._user.professionalData.cidadesAtuantes;
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
              widget._user.name,
//            '',
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
              widget._user.email,
//              '',
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
            widget._user.professionalData.telefone,
//            '',
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

    final informacoesBasicas = Padding(
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
          informacoesBasicas,
          emailTelRatingGroup,
          _VERTICAL_SEPARATOR,
          myDivisor.divisorGroup('Cidades'),
          _cidades(),
          myDivisor.divisorGroup('Serviços'),
          ServiceListProfissionalWidget(serviceList: servicoList, user: widget._user),
          _editingPerfilTextGroup
//          _textEditingCidadePt1
        ],
      ),
    );


    List<Widget> list = new List();
    list.add(form);
    return list;
  }

  Widget _showScreen(){
//    _progressBarHandler.show();
    return Center(
          child: Stack(
            children: _buildForm(),
          ),
        );
  }



  @override
  Widget build(BuildContext context) {
    var modal = ModalRoundedProgressBar(
        handleCallback: (handler){
//          _progressBarHandler = handler;
        });
    return Stack(
      children: <Widget>[
        _showScreen(),
        modal
      ],
    );
  }

}