import 'package:autonos_app/ui/ui_cadastro_autonomo/Atuacao.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/PerfilDetalhe.dart';
import 'package:autonos_app/utility/InputValidator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:autonos_app/ui/widget/GenericDataListScreen.dart';

class CadastroAutonomoPt1 extends StatefulWidget {
  @override
  CadastroAutonomoPt1State createState() => CadastroAutonomoPt1State();
}

class CadastroAutonomoPt1State extends State<CadastroAutonomoPt1> {
  int _radioValue = 0;
  String _tipoPessoa = '';

  var typeCpfMask;
  var typeCnpjMask;
  var typeTelefoneMask;

  FocusNode _tipoPessoaFocus;
  FocusNode _descricaoFocus;
  FocusNode _telefoneFocus;

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
    typeTelefoneMask = new MaskedTextController(mask: '(00) 00000-0000');

    _tipoPessoaFocus = new FocusNode();
    _descricaoFocus = new FocusNode();
    _telefoneFocus = new FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _tipoPessoaFocus.dispose();
    _descricaoFocus.dispose();
    _telefoneFocus.dispose();
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

    //cpfAndCnpjField.
    var phoneField = Material(
      child: TextFormField(
        focusNode: _telefoneFocus,
        controller: typeTelefoneMask,
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


    var documentsButton = /*Padding(
        padding: EdgeInsets.symmetric(horizontal: .0, vertical: 16.0),
        child: */RaisedButton(

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


    var nextStepButton = RaisedButton(
          padding: EdgeInsets.fromLTRB(.0, 8.0, .0, 8.0),
          onPressed: (){
            if (_inputValidation()){
              Navigator.of(context).push(
                  MaterialPageRoute(builder:
                      (BuildContext context) => Atuacao() )
              );
            }
          },

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '[1/3]   Próximo Passo',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.directions_run,color: Colors.white,),
              ),
            ],
          ),
          color: Colors.red[300],
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
        nextStepButton,
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
