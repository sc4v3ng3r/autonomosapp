import 'dart:collection';

import 'package:autonos_app/firebase/FirebaseServicesHelper.dart';
import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/widget/CityChipContainer.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:flutter/material.dart';

class PerfilDetailsWidget extends StatefulWidget {
  final User _user;
  final SizedBox _SEPARATOR = SizedBox(height: 8.0,);

  PerfilDetailsWidget({@required User user}): _user = user;
  @override
  _PerfilDetailsWidgetState createState() => _PerfilDetailsWidgetState();
}

class _PerfilDetailsWidgetState extends State<PerfilDetailsWidget> {

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = List();
    final User user = widget._user;

    var header = _createHeader();
    var userName = createSimpleTextRow(user.name, fontSize: 22.0);
    var userEmail =  createSimpleTextRow(user.email);

    var userRatingBar = Row(
      children: <Widget>[
        RatingBar( rating: user.rating, ),
        Text("(${user.rating})", style: TextStyle(
          fontSize: 16.0,
        ),),
      ],
    );

    widgetList.add( userName);
    widgetList.add(widget._SEPARATOR);

    widgetList.add( userRatingBar );
    widgetList.add(widget._SEPARATOR);

    widgetList.add( userEmail);
    widgetList.add(widget._SEPARATOR);


    var changePassword = GestureDetector(
      child: createSimpleTextRow("Alterar Senha", fontSize: 20, color: Colors.blue),
      onTap: (){
        print("Change password screen");
      },
    );

    if (user.professionalData!=null){
      var userPhone = createSimpleTextRow(
          widget._user.professionalData.telefone, fontSize: 18.0);
      widgetList.add(userPhone);
      widgetList.add(widget._SEPARATOR);
      widgetList.add(changePassword);
      widgetList.add(widget._SEPARATOR);

      var userDescription = Row(
        children: <Widget>[
          Text(user.professionalData.descricao,
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black
            ),
          )
        ],
      );

      //insere a descricao la em cima na lista...
      widgetList.insert(1, userDescription);
      var cityChipContainer = ChipPanelWidget(
        title: "Cidades Atuantes",
        data: user.professionalData.cidadesAtuantes,
      );

      widgetList.add( cityChipContainer );
      widgetList.add( widget._SEPARATOR );
    }

    else {
      widgetList.add( changePassword );
      widgetList.add( widget._SEPARATOR );
    }

    var deleteAccountButton = Align(
          alignment: FractionalOffset.bottomCenter,
          child: RaisedButton(
            color: Colors.red,
            splashColor: Colors.pink,
            onPressed: (){},
            child: Text("Apagar Conta",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0
              ),
            ),
          ),
        );

    widgetList.add(deleteAccountButton);

    var infoGroup= Card(

      child: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: Column(
          children: widgetList,
        ),
      ),
    );

    return  ListView(
      children: <Widget>[
        header,
        infoGroup,
      ],
    );
    
  }

  Widget createSimpleTextRow(String text, { double fontSize = 16.0,
    Color color = Colors.black} ){

    return Row(
      children: <Widget>[
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              color: color,
              fontSize: fontSize
          ),
        ),
      ],
    );
  }

  Widget _createHeader(){
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/usuario.png"),
        ),

        title: Text(widget._user.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),

        trailing: GestureDetector(
          child: Text("Editar",
            style: TextStyle(
                color: Colors.blue,
                fontSize: 20.0
            ),
          ),
          onTap: (){
            print("EDIT user name tapped");
          },
        ),
      ),
    );
  }

}

class ChipPanelWidget extends StatefulWidget {

  final Function _onEditClicked;
  final String _title;
  final List<String> _data;

  ChipPanelWidget( { @required String title, Function onEditCallback(List<String> data),
      List<String> data } )
    : _title = title,
      _onEditClicked = onEditCallback,
      _data = data;

  @override
  _ChipPanelWidgetState createState() => _ChipPanelWidgetState();
}

class _ChipPanelWidgetState extends State<ChipPanelWidget> {
  List<Widget> chipList = List();
  @override
  void initState() {
    super.initState();
    for (String data in widget._data)
      chipList.add( Chip(label: Text(data),) );
  }

  @override
  Widget build(BuildContext context) {
    var divisor = _createDivisor(widget._title);

    return Column(
      children: <Widget>[
        divisor,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              child: Icon(Icons.edit, color: Colors.blue,),
              onTap: (){
                print("chip panel callback");
                if (widget._onEditClicked != null)
                  widget._onEditClicked(widget._data);
              },
            ),
          ],
        ),
        Wrap( children: chipList, spacing: 2.0, ),
      ],
    );
  }

  Widget _createDivisor(String text){
    final leftLine = Expanded(
      child:Container(
        color: Colors.grey[300],
        height: 1.0,
        margin: EdgeInsets.only(right: 8.0),
      ),
    );

    final rightLine = Expanded(
      child: Container(
        color: Colors.grey[300],
        height: 1.0,
        margin: EdgeInsets.only(left: 8.0),
      ),
    );

    return Row(
      children: <Widget>[
        leftLine,
        Text(text),
        rightLine,
      ],
    );
  }
}

