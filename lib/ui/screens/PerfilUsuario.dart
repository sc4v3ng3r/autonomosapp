import 'package:autonos_app/ui/widget/AccountDetailsLayout.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:flutter/material.dart';

class PerfilUsuario extends StatefulWidget {
  @override
  PerfilUsuarioState createState() => PerfilUsuarioState();
}

class PerfilUsuarioState extends State<PerfilUsuario> {
  static double _nota = 4.3;
  final SizedBox _VERTICAL_SEPARATOR = SizedBox(
    height: 16.0,
  );

  RatingBar ratingBar = new RatingBar(rating: _nota);

  List<Widget> servicoList = [
    Chip(label: Text('Pedreiro'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
    Chip(label: Text('Padeiro'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
    Chip(label: Text('Costureira'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
    Chip(label: Text('Eletricista'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
    Chip(label: Text('Caseiro'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
    Chip(label: Text('Jardineiro'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
  ];

  List<Widget> cidadesList = [
    Chip(label: Text('Feira de Santana'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
    Chip(label: Text('Serrinha'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
    Chip(label: Text('Nova Fátima'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
    Chip(label: Text('Riachão'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
    Chip(label: Text('Santa Barbara'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
    Chip(label: Text('Humildes'),padding: EdgeInsets.all(4.0),backgroundColor: Colors.white,),
  ];

  Widget _servicos(){
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Card(
//        margin: EdgeInsets.all(-3.0),
        color: Colors.blueGrey,
        child: ExpansionTile(
          title: Text('Meus serviços',style: TextStyle(color: Colors.white),),
          children: <Widget>[
            Wrap(
              children: servicoList,
            )
          ],
        ),
      ),
    );
  }

  Widget _cidades(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child:       Card(
        color: Colors.red[300],
        child: ExpansionTile(
          title: Text('Cidades',style: TextStyle(color: Colors.white),),
          children: <Widget>[
            Wrap(
              children: cidadesList,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildForm() {

    final nome = Expanded(
      child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              'Usuário do Autonomos',
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
              'email@email.com',
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
            '(00)00000-0000',
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
          '($_nota)',
          style: TextStyle(color: Colors.blueGrey),
        ),
      ],
    );


    final divisor1 = Expanded(child: Container(
      color: Colors.grey[300],
      height: 1.0,
      padding: EdgeInsets.fromLTRB(16.0, .0, .0, .0),
      margin: EdgeInsets.fromLTRB(16.0, .0, 8.0, .0),
    ));

    final divisor = Row(
      children: <Widget>[divisor1],
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

    final form = Form(
      child: ListView(
        children: <Widget>[
          InformacoesBasicas,
          emailTelRatingGroup,
          _VERTICAL_SEPARATOR,
          divisor,
          _cidades(),
          _servicos()
        ],
      ),
    );
    List<Widget> list = new List();
    list.add(form);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
      child: Stack(
        children: _buildForm(),
      ),
    ));
  }
}
