import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/widget/MyDivisorLayout.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:flutter/material.dart';

class PerfilUsuarioComumScreen extends StatefulWidget{
  final User _user;

  PerfilUsuarioComumScreen({@required User user}): _user = user;

  @override
  PerfilUsuarioComumScreenState createState() => PerfilUsuarioComumScreenState();
}

class PerfilUsuarioComumScreenState extends State<PerfilUsuarioComumScreen>{

  RatingBar ratingBar;
  double ratingUser;
  MyDivisor myDivisor;
  static const SizedBox _VERTICAL_SEPARATOR = SizedBox(
    height: 16.0,
  );
  @override
  void initState() {
    myDivisor = new MyDivisor();
    ratingBar = new RatingBar(rating: widget._user.rating,);
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
        )
    );
    final emailTelRatingGroup = Column(
      children: <Widget>[rating, email],
    );

    final form = Form(
      child: ListView(
        children: <Widget>[
          informacoesBasicas,
          emailTelRatingGroup,
          _VERTICAL_SEPARATOR,
          myDivisor.divisorComplete()
//          _textEditingCidadePt1
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
        child: Stack(
          children: _buildForm()
        ),
      ),
    );
  }

}