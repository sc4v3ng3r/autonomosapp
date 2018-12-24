import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/screens/ui_cadastro_autonomo/ProfessionalRegisterBasicInfoScreen.dart';
import 'package:autonos_app/ui/widget/MyDivisorLayout.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:flutter/material.dart';

class PerfilUsuarioComumScreen extends StatefulWidget {
  final User _user;

  PerfilUsuarioComumScreen({@required User user}) : _user = user;

  @override
  PerfilUsuarioComumScreenState createState() =>
      PerfilUsuarioComumScreenState();
}

class PerfilUsuarioComumScreenState extends State<PerfilUsuarioComumScreen> {
  String name = '';
  RatingBar ratingBar;
  double ratingUser;
  MyDivisor myDivisor;
  static const SizedBox _VERTICAL_SEPARATOR = SizedBox(
    height: 16.0,
  );

  @override
  void initState() {
    name = widget._user.name;
    myDivisor = new MyDivisor();
    ratingBar = new RatingBar(
      rating: widget._user.rating,
    );
    ratingUser = ratingBar.rating;
    super.initState();
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
        ));
    final emailTelRatingGroup = Column(
      children: <Widget>[rating, email],
    );
//    final habilidadeText = Flexible(
//        child:Text(
//          'habilidade, ',
//          style: TextStyle(color: Colors.green[300]),
//        ),
//    );
//
//    final fraseConvite_1 =  Flexible(
//      child: Text('Você possui alguma '),
//    );
////    final fraseConvite = Flexible(
////        child: Text(
////            'Você possui alguma habilidade, ou já é um profissional de alguma area?'
////        ),
////      );
//    final fraseConvite_2 = Flexible(
//      child: Text(
//        'ou já é '
//      ),
//    );
    final fraseSaldacao = Padding(
        padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, 4.0),
//        child: Text('Olá $name, tudo bem?',style: TextStyle(color: Colors.grey),));
        child: Row(
          children: <Widget>[
            Flexible(
                child: RichText(
                    text: TextSpan(
                        text: 'Olá ',
                        style: TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                  TextSpan(
                      text: '$name',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: ', tudo bem?', style: TextStyle(color: Colors.grey))
                ]))),
          ],
        ));
    final fraseConvite = Flexible(
      child: RichText(
          text: TextSpan(
        text: 'Você possui alguma ',
        style: TextStyle(color: Colors.grey),
        children: <TextSpan>[
          TextSpan(
              text: 'habilidade', style: TextStyle(color: Colors.green[300])),
          TextSpan(text: ', ou já é um ', style: TextStyle(color: Colors.grey)),
          TextSpan(
              text: 'profissinal', style: TextStyle(color: Colors.green[300])),
          TextSpan(
              text: ' de alguma área?', style: TextStyle(color: Colors.grey)),
          TextSpan(text: ' Não', style: TextStyle(color: Colors.grey)),
          TextSpan(text: ' perca', style: TextStyle(color: Colors.red[300])),
          TextSpan(text: ' seu tempo!', style: TextStyle(color: Colors.grey)),
        ],
      )),
    );
    final autonomosConvite = Padding(
      padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, .0),
      child: Row(
        children: <Widget>[fraseConvite],
      ),
    );

    final cadastroButton = Center(
      child: RaisedButton(
        splashColor: Colors.red,
        child: Text(
          'Seja um autonomo!',
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  ProfessionalRegisterBasicInfoScreen()));
        },
        color: Colors.green[300],
      ),
    );

    final form = Form(
      child: ListView(
        children: <Widget>[
          informacoesBasicas,
          emailTelRatingGroup,
          _VERTICAL_SEPARATOR,
          myDivisor.divisorComplete(),
          _VERTICAL_SEPARATOR,
          fraseSaldacao,
          autonomosConvite,
          _VERTICAL_SEPARATOR,
          _VERTICAL_SEPARATOR,
          cadastroButton
        ],
      ),
    );

    List<Widget> list = new List();
    list.add(form);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: _buildForm()),
      ),
    );
  }
}
