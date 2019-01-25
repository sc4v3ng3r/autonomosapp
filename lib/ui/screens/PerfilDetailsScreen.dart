import 'package:autonos_app/model/Service.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/screens/PaymentDataEditorScreen.dart';
import 'package:autonos_app/ui/screens/ServiceEditorScreen.dart';
import 'package:autonos_app/ui/widget/RatingBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/widget/ChipPanelWidget.dart';
import 'package:autonos_app/bloc/PerfilDetailsScreenBloc.dart';
import 'package:autonos_app/ui/screens/LocationEditorScreen.dart';

// TODO renomear para Widget ou Fragment, pq essa widget NÃO É UMA TELA!
class PerfilDetailsScreen extends StatefulWidget {
  final User _user;
  final SizedBox _SEPARATOR = SizedBox(height: 8.0,);

  PerfilDetailsScreen({@required User user}): _user = user;

  @override
  _PerfilDetailsScreenState createState() => _PerfilDetailsScreenState();
}

class _PerfilDetailsScreenState extends State<PerfilDetailsScreen> {
  PerfilDetailsScreenBloc _bloc;

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = List();
    final User user = widget._user;

    var header = _createHeader();
    var userName = createTextRow(user.name, fontSize: 22.0);
    var userEmail =  createTextRow(user.email);

    var userRatingBar = Row(
      children: <Widget>[
        RatingBar( rating: user.rating, ),
        Text("(${user.rating})", style: TextStyle(
          fontSize: 16.0,
        ),),
      ],
    );

    widgetList.add( userName);//0
    //widgetList.add(widget._SEPARATOR);//1
    widgetList.add( userRatingBar );//1
    widgetList.add(widget._SEPARATOR);//2
    widgetList.add( userEmail);//3

    var changePassword = GestureDetector(
      child: createTextRow("Alterar Senha", fontSize: 20, color: Colors.blue),
      onTap: (){
        print("Change password screen");
      },
    );

    if (user.professionalData!=null){
      _bloc = PerfilDetailsScreenBloc(user.professionalData.servicosAtuantes);

      var userPhone = createTextRow(
          widget._user.professionalData.telefone, fontSize: 20.0, preIcon: Icon(Icons.phone));

      var userDescription = createTextRow(user.professionalData.descricao,
        fontSize: 14.0, color: Colors.black);

      //insere a descricao la em cima na lista...
      widgetList.insert(1, userDescription);

      var emissor = user.professionalData.emissorNotaFiscal;
      var userNote = createTextRow("Emite nota fiscal:",
          afterIcon: (emissor == true) ? Icon(Icons.done, color: Colors.green ) :

      Icon( Icons.clear, color: Colors.red,));
      widgetList.insert(3, userNote);
      widgetList.insert(4, widget._SEPARATOR);
      widgetList.insert(5, userPhone);
      widgetList.add(changePassword);
      widgetList.add(widget._SEPARATOR);

      var cityChipContainer = ChipPanelWidget<String>(
        title: "Cidades Atuantes",
        editable: true,
        data: user.professionalData.cidadesAtuantes,
        onEditCallback: (userCityNamesList){
          Navigator.push(context, MaterialPageRoute(
              builder: (buildContext){
                return LocationEditorScreen(
                  initialState: user.professionalData.estadoAtuante,
                  userCities: user.professionalData.cidadesAtuantes,
                );
              })
          );
        } ,
      );

      widgetList.add( cityChipContainer );
      widgetList.add( widget._SEPARATOR );

      var servicesChipContainer = ChipPanelWidget<Service>(
        title: "Serviços Atuantes",
        editable: true,
        dataStream: _bloc.userServices,
        onEditCallback: (serviceList){
          Navigator.push(context, MaterialPageRoute(builder: (buildContext){
              return ServiceEditorScreen(
                  currentServicesList: serviceList,
              );
            }),
          );
        },
      );

      widgetList.add( servicesChipContainer );
      widgetList.add( widget._SEPARATOR );

      var paymentPanel = ChipPanelWidget<String>(
        title: "Formas de pagamento",
        data: user.professionalData.formasPagamento,
        editable: true,
        onEditCallback: (dataList){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return PaymentDataEditorScreen(
              payments: dataList,
              emissorData: user.professionalData.emissorNotaFiscal,
            );
          }) );
        },
      );

      widgetList.add( paymentPanel);
    }

    else {
      widgetList.add( changePassword );
      widgetList.add( widget._SEPARATOR );
    }
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

  /// Método para criação de linhas que podem conter, um Icone inicial,
  /// um texto, e um icone final.
  Widget createTextRow(String text, { double fontSize = 16.0,
    Color color = Colors.black, Icon preIcon, Icon afterIcon } ){
    List<Widget> widgets = List();

    var textWidget =  Flexible(
        child: Text(
          text,
          overflow: TextOverflow.clip,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
              color: color,
              fontSize: fontSize
          ),
        ),
      flex: 1,
      fit: FlexFit.loose,
    );

    if (preIcon !=null){
      widgets.add( preIcon );
      widgets.add( SizedBox(width: 5.0,) );
    }

    widgets.add( textWidget );

    if (afterIcon!= null){
      //widgets.add( textWidget );
      widgets.add(SizedBox(width: 5.0,));
      widgets.add( afterIcon );
    }

    return Row( children: widgets);
  }

  Widget _createHeader(){
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: (widget._user.picturePath == null)
              ? AssetImage("assets/usuario.png") : CachedNetworkImageProvider(widget._user.picturePath),
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