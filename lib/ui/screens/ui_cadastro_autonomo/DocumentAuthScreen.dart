import 'package:autonomosapp/bloc/ProfessionalRegisterFlowBloc.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/ProfessionalRegisterLocationAndServiceScreen.dart';
import 'package:autonomosapp/ui/widget/DocumentRowPictureWidget.dart';
import 'package:autonomosapp/ui/widget/NextButton.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';

class DocumentsAuthScreen extends StatelessWidget {
  final ProfessionalRegisterFlowBloc _registerFlowBloc;

  DocumentsAuthScreen({@required ProfessionalRegisterFlowBloc registerFlowBloc})
    : _registerFlowBloc = registerFlowBloc;

  @override
  Widget build(BuildContext context) {

    final logoImage = Container(
      width: 320,
      child: Image.asset( Constants.ASSETS_NOME_LOGO, fit: BoxFit.fitWidth),
    );

    final imageRow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[ logoImage, ],
    );

    var mainText = Expanded(
      child: Text(
        "Ganhe a confiança de possíveis clientes com o selo autêntico de profissional autônomo!"
            " Tudo que você precisa fazer é somente validar sua identidade fornecendo fotos"
            " autênticas de seu documento de identificação (RG).",
        textAlign: TextAlign.left,
        maxLines: 5,
        softWrap: true,
      ),
    );

    final textRow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        mainText,
      ],
    );

    final widget = DocumentRowPictureWidget(
      frenteRgCallback: _registerFlowBloc.insertRgFrenteFoto,
      versoRgCallback: _registerFlowBloc.insertRgVersoFoto,
      pessoaRgCallback: _registerFlowBloc.insertFotoPessoalComRg,
    );


    final nextButton = NextButton(
      buttonColor: Colors.green,
      text: '[2/4]   Próximo Passo',
      textColor: Colors.white,
      callback: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) =>
              ProfessionalRegisterLocationAndServiceScreen(
                bloc: _registerFlowBloc,
              )
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Autênticação"),
        brightness: Brightness.dark,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            imageRow,
            Constants.VERTICAL_SEPARATOR_16,
            Constants.VERTICAL_SEPARATOR_16,
            textRow,
            Constants.VERTICAL_SEPARATOR_16,
            widget,
            Constants.VERTICAL_SEPARATOR_16,
            Constants.VERTICAL_SEPARATOR_16,
            nextButton,
          ],
        ),
      ),
    );
  }
}
