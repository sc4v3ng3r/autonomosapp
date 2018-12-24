import 'package:autonos_app/bloc/ProfessionalRegisterFlowBloc.dart';
import 'package:autonos_app/ui/screens/ui_cadastro_autonomo/ProfessionalRegisterLocationAndServiceScreen.dart';
import 'package:autonos_app/ui/widget/NextButton.dart';
import 'package:autonos_app/utility/InputValidator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:autonos_app/model/ProfessionalData.dart';

class ProfessionalRegisterBasicInfoScreen extends StatefulWidget {
  @override
  ProfessionalRegisterBasicInfoScreenState createState() => ProfessionalRegisterBasicInfoScreenState();
}

class ProfessionalRegisterBasicInfoScreenState extends State<ProfessionalRegisterBasicInfoScreen> {
  int _radioValue = 0;
  String _tipoPessoa = '';
  //TODO SOMENTE ENQUANTO NÃO TEMOS BLOC
  //ProfessionalData _profissionalData;
  var typeCpfMask;
  var typeCnpjMask;

  MaskedTextController _typeTelefoneMask;
  TextEditingController _tellMeAboutYouController;

  FocusNode _tipoPessoaFocus;
  FocusNode _descricaoFocus;
  FocusNode _telefoneFocus;
  ProfessionalRegisterFlowBloc _bloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autoValidade = false;
  bool _contextChanged = false;

  static const SizedBox _VERTICAL_SEPARATOR = SizedBox(height: 16.0,);
  static const SizedBox _FIELD_SEPARATOR = SizedBox(height: 10.0);
  static const String _CPF = 'CPF';
  static const String _CNPJ = 'CNPJ';

  void _handleRadioValueChange(int i) {
    _radioValue = i;
    print("handling radio value: $i");

    _contextChanged = true;
    setState(() {
      switch (_radioValue) {
        case 0:
          _tipoPessoa = _CPF;
          break;
        case 1:
          _tipoPessoa = _CNPJ;
          break;
      }
    }
    );
  }

  @override
  void initState() {
    _radioValue = 0;
    _tipoPessoa = _CPF;

    typeCpfMask = new MaskedTextController(mask: '000.000.000-00', text: _CPF);
    typeCnpjMask = new MaskedTextController(mask: '00.000.000/0000-00', text: _CNPJ);
    _typeTelefoneMask = new MaskedTextController(mask: '(00) 00000-0000');
    _tellMeAboutYouController = TextEditingController();

    _tipoPessoaFocus = new FocusNode();
    _descricaoFocus = new FocusNode();
    _telefoneFocus = new FocusNode();
    _bloc = new ProfessionalRegisterFlowBloc();

    super.initState();
  }

  @override
  void dispose() {
    _tipoPessoaFocus.dispose();
    _descricaoFocus.dispose();
    _telefoneFocus.dispose();
    _tellMeAboutYouController.dispose();
    super.dispose();
  }

  MaskedTextController _typeCpfOrCnpj() {
    if (_tipoPessoa == _CPF)
      return typeCpfMask;
    else
      return typeCnpjMask;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Informações Básicas',
            style: TextStyle(color: Colors.blueGrey),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.red[400]),
        ),
        body: _buildLayout(),

    );
  }

  Widget _buildLayout(){

    var userPicture = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage("assets/usuario_drawer.png"),
          backgroundColor: Colors.blueGrey,
          maxRadius: 48.0,
        ),
      ],
    );

    var radioGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: 0,
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
          activeColor: Colors.red[400],
        ),
        new Text('Pessoa Física'),
        new Radio(
          value: 1,
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
          activeColor: Colors.red[400],
        ),
        new Text('Pessoa Jurídica')
      ],
    );

    var cpfAndCnpjField = TextFormField(
          maxLines: 1,
          autofocus: false,
          controller: _typeCpfOrCnpj(),
          validator: (String data) {
            print("validator method");
            if (_contextChanged){
              _contextChanged = false;
              return null;
            }

            if (_tipoPessoa ==_CPF)
              return InputValidator.cpfValidation(data);
            else
              return InputValidator.cnpjValidation(data);
          },

          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          focusNode: _tipoPessoaFocus,
          onFieldSubmitted: (dataTyped) {
            _tipoPessoaFocus.unfocus();
            FocusScope.of(context).requestFocus(_telefoneFocus);
          },
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              labelText: _tipoPessoa,
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0)
              )
          ),
    );

    var phoneField = Material(
      child: TextFormField(
        focusNode: _telefoneFocus,
        controller: _typeTelefoneMask,
        autofocus: false,
        keyboardType: TextInputType.number,
        maxLines: 1,
        validator: InputValidator.phoneValidation,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (dataTyped) {
          _telefoneFocus.unfocus();
          FocusScope.of(context).requestFocus(_descricaoFocus);
        },
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            labelText: "Telefone",
            labelStyle: TextStyle(
              fontSize: 18.0,
            ),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.0)
            )
        ),
      ),
    );

    var personalForm = Form(
      key: _formKey,
      autovalidate: _autoValidade,
      child: Column(
        children: <Widget>[
          userPicture,
          radioGroup,
          _FIELD_SEPARATOR,
           cpfAndCnpjField,
          _FIELD_SEPARATOR,
          phoneField,
        ],
      ),
    );


    var documentsButton = RaisedButton(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(.0, 8.0, .0, 8.0),
          onPressed: initState,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.fingerprint,color: Colors.blueGrey,),
              ),
              Expanded(
                child: Text(
                  'Insira seus documentos',
                  style: TextStyle(color: Colors.red[300]),),
              ),
            ],
          ),
        //)
    );

    var tellMeAboutYouField = TextFormField(
      autofocus: false,
      focusNode: _descricaoFocus,
      controller: _tellMeAboutYouController,
      maxLength: 48,
      maxLines: 4,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (dataTyped) {
        setState(() {
          _descricaoFocus.unfocus();
        });
      },
      decoration: InputDecoration(
          labelText: 'Fale um pouco de você',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          )
      ),
    );

    var nextButton = NextButton(
      buttonColor: Colors.green[300],
      text: '[1/3]   Próximo Passo',
      textColor: Colors.white,
      callback: (){

        if(_inputValidation()){
          _bloc.insertBasicProfessionalInformation(
                typePeople: _tipoPessoa,
                documentNumber: _typeCpfOrCnpj().text,
                phone: _typeTelefoneMask.text,
                description: _tellMeAboutYouController.text);
          /*
          _profissionalData = ProfessionalData();
          _profissionalData.tipoPessoa = _tipoPessoa;
          _profissionalData.documento = _typeCpfOrCnpj().text;
          _profissionalData.telefone = _typeTelefoneMask.text;
          _profissionalData.descricao = _tellMeAboutYouController.text;
          */
          //TODO falta as referencias aos documentos "fotos"

          Navigator.of(context).push(
              MaterialPageRoute(builder:
                  (BuildContext context) =>
                      ProfessionalRegisterLocationAndServiceScreen(
                        bloc: _bloc,
                      )
              ),
          );
        }
      },
    );

    return ListView(
      padding: EdgeInsets.fromLTRB(10.0, .0 , 10.0, 0.0),
      children: <Widget>[
        _VERTICAL_SEPARATOR,
        personalForm,
        _VERTICAL_SEPARATOR,
        documentsButton,
        _VERTICAL_SEPARATOR,
        tellMeAboutYouField,
        _FIELD_SEPARATOR,
        nextButton,
      ],
      shrinkWrap: true,
    );
  }

  bool _inputValidation(){

    if (_formKey.currentState.validate() ){
      // se o formulario foi validado!!
      //obtem os dados inseridos em objeto conjunto!!
      return true;
    }

    _turnOnAutoValidate(true);
    return false;
  }

  void _turnOnAutoValidate(bool on){
    setState( () {
      _autoValidade = on;
    });
  }

}
