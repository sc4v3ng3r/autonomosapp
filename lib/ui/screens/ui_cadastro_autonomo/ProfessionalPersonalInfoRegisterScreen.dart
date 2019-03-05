import 'dart:io';

import 'package:autonomosapp/bloc/ProfessionalRegisterFlowBloc.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/DocumentAuthScreen.dart';
import 'package:autonomosapp/ui/screens/ui_cadastro_autonomo/ProfessionalRegisterLocationAndServiceScreen.dart';
import 'package:autonomosapp/ui/widget/ChoosePictureBottomSheetWidget.dart';
import 'package:autonomosapp/ui/widget/GenericInfoWidget.dart';
import 'package:autonomosapp/ui/widget/NextButton.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/InputValidator.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:autonomosapp/ui/widget/CircularPictureWidget.dart';


class ProfessionalPersonalInfoRegisterScreen extends StatefulWidget {
  @override
  ProfessionalPersonalInfoRegisterScreenState createState() => ProfessionalPersonalInfoRegisterScreenState();
}

class ProfessionalPersonalInfoRegisterScreenState extends State<ProfessionalPersonalInfoRegisterScreen> {
  int _radioValue = 0;
  String _tipoPessoa = '';
  //TODO SOMENTE ENQUANTO NÃO TEMOS BLOC
  //ProfessionalData _profissionalData;
  var typeCpfMask;
  var typeCnpjMask;

  MaskedTextController _typeTelefoneMask;
  TextEditingController _userDescriptionController;

  FocusNode _tipoPessoaFocus;
  FocusNode _descricaoFocus;
  FocusNode _telefoneFocus;
  ProfessionalRegisterFlowBloc _bloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = UserRepository.instance.currentUser;
  bool _autoValidade = false;
  bool _contextChanged = false;

  static const SizedBox _FIELD_SEPARATOR = SizedBox(height: 10.0);
  static const String _CPF = 'CPF';
  static const String _CNPJ = 'CNPJ';
  final UserRepository _repository = UserRepository.instance;

  String _selectedPicturePath;
  PictureTypeCode _pictureTypeCode;
  CircularPictureWidgetBloc _circularPictureWidgetBloc;

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
    super.initState();
    _radioValue = 0;
    _tipoPessoa = _CPF;

    typeCpfMask = new MaskedTextController(mask: '000.000.000-00', text: _CPF);
    typeCnpjMask = new MaskedTextController(mask: '00.000.000/0000-00', text: _CNPJ);
    _typeTelefoneMask = new MaskedTextController(mask: '(00) 00000-0000');
    _userDescriptionController = TextEditingController();

    _tipoPessoaFocus = new FocusNode();
    _descricaoFocus = new FocusNode();
    _telefoneFocus = new FocusNode();
    _bloc = new ProfessionalRegisterFlowBloc();

    _circularPictureWidgetBloc = CircularPictureWidgetBloc(
        initialImageProvider: (_user.picturePath == null) ?
            AssetImage(Constants.ASSETS_LOGO_USER_PROFILE_FILE_NAME) :
            CachedNetworkImageProvider(_user.picturePath)
    );
  }

  @override
  void dispose() {
    _tipoPessoaFocus?.dispose();
    _descricaoFocus?.dispose();
    _telefoneFocus?.dispose();
    _userDescriptionController?.dispose();
    _circularPictureWidgetBloc?.dispose();
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
          title: Text( 'Informações Pessoais',),
          brightness: Brightness.dark,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: _buildLayout(),
        )

    );
  }

  Widget _buildLayout(){
    final userPicture = CircularPictureWidget(
      bloc: _circularPictureWidgetBloc,
      size: 130,
      onClickCallback: _showModalBottomSheet,
    );

    /*final userPicture = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //TODO opção de trocar a foto!
        CircleAvatar(
          backgroundImage: (_repository.currentUser.picturePath== null) ?
            AssetImage( Constants.ASSETS_LOGO_USER_PROFILE_FILE_NAME) :
            CachedNetworkImageProvider(_repository.currentUser.picturePath ),
          maxRadius: 48.0,
        ),
      ],
    );*/

    final radioGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: 0,
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
          activeColor: Theme.of(context).primaryColor,
        ),
        new Text('Pessoa Física'),
        new Radio(
          value: 1,
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
          activeColor: Theme.of(context).primaryColor,
        ),
        new Text('Pessoa Jurídica')
      ],
    );

    final cpfAndCnpjField = TextFormField(
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
            color: Theme.of(context).accentColor,
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

    final phoneField = Material(
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
            color: Theme.of(context).accentColor
        ),

        decoration: InputDecoration(
            labelText: "Telefone",
            labelStyle: TextStyle( fontSize: 18.0, ),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.0)
            )
        ),
      ),
    );

    /*final documentsButton = RaisedButton(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(.0, 8.0, .0, 8.0),
          onPressed: (){},
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.fingerprint ),
              ),
              Expanded(
                child: Text(
                  'Insira seus documentos'),
              ),
            ],
          ),
    );*/

    final userDescriptionField = TextFormField(
      autofocus: false,
      focusNode: _descricaoFocus,
      controller: _userDescriptionController,
      maxLength: 48,
      maxLines: 4,
      validator: InputValidator.descriptionValidation,
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

    final personalForm = Form(
      key: _formKey,
      autovalidate: _autoValidade,
      child: Column(
        children: <Widget>[
          userPicture,
          Text("Alterar foto"),
          radioGroup,
          _FIELD_SEPARATOR,
          cpfAndCnpjField,
          _FIELD_SEPARATOR,
          phoneField,
          //Constants.VERTICAL_SEPARATOR_16,
          //documentsButton,
          Constants.VERTICAL_SEPARATOR_16,
          userDescriptionField,
        ],
      ),
    );


    final nextButton = NextButton(
      buttonColor: Colors.green,
      text: '[1/4]   Próximo Passo',
      textColor: Colors.white,
      callback: (){

        if( _inputValidation() ){

          Map<PictureTypeCode,String> pictureData =
          {
            _pictureTypeCode : _selectedPicturePath ?? _user.picturePath
          };

          print("CURRENT TYPE: $_pictureTypeCode\nPATH: ${pictureData[_pictureTypeCode]}");
          _bloc.insertBasicProfessionalInformation(
                typePeople: _tipoPessoa,
                profilePicture: pictureData,
                documentNumber: _typeCpfOrCnpj().text,
                phone: _typeTelefoneMask.text,
                description: _userDescriptionController.text);

          //TODO falta as referencias aos documentos "fotos"
          Navigator.of(context).push(
            MaterialPageRoute(builder:
                (BuildContext context) =>
                DocumentsAuthScreen(
                  registerFlowBloc: _bloc,
                ),
            ),
          );

          /*
          Navigator.of(context).push(
              MaterialPageRoute(builder:
                  (BuildContext context) =>
                      ProfessionalRegisterLocationAndServiceScreen(
                        bloc: _bloc,
                      )
              ),
          );*/
        }
      },
    );

    final padding = Padding(
      padding: EdgeInsets.fromLTRB(10.0, .0 , 10.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Constants.VERTICAL_SEPARATOR_16,
          personalForm,
          _FIELD_SEPARATOR,
          nextButton,
        ],
      ),
    );

    return padding;
  }

  PictureTypeCode _typeOfProfilePicture(){
    if (_user.picturePath != null)
      return PictureTypeCode.NETWORK_PICTURE;

    else if (_selectedPicturePath != null)
      return PictureTypeCode.LOCAL_FILE_PICTURE;

    return PictureTypeCode.NONE;

  }

  void _showProfilePictureDialog() =>
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: GenericInfoWidget(
              title: "Foto de perfil é obrigatória!",
              icon: Icons.account_circle,
              iconSize: 140,
              iconColor: Theme.of(context).errorColor,
              subtitle: "Selecione uma foto para seu perfil.",
            ),
          );
        }
    );

  bool _inputValidation(){
    var flag= _formKey.currentState.validate();

    if ( flag ){
      _pictureTypeCode = _typeOfProfilePicture();

      switch (_pictureTypeCode){
        case PictureTypeCode.LOCAL_FILE_PICTURE:
        case PictureTypeCode.NETWORK_PICTURE:
          return flag;
          break;

        default:
          _showProfilePictureDialog();
          return false;
          break;
      }
    }

    _turnOnAutoValidate(true);
    return flag;
  }

  void _turnOnAutoValidate(bool on){
    setState( () { _autoValidade = on; });
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ChoosePictureBottomSheetWidget(
            onSelected: (pictureFile) {
              Navigator.pop(context);
              if (pictureFile != null) {
                _circularPictureWidgetBloc.addToSink(
                  FileImage(pictureFile),
                );
                _selectedPicturePath = pictureFile.path;
              }
            },
          );
        });
  }
}
