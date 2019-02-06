import 'dart:io';
import 'package:autonomosapp/firebase/FirebaseAuthHelper.dart';
import 'package:autonomosapp/firebase/FirebaseStorageHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/ui/widget/ChoosePictureBottomSheetWidget.dart';
import 'package:autonomosapp/ui/widget/ModalRoundedProgressBar.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/TextInputWidget.dart';
import 'package:autonomosapp/ui/widget/CircularPictureWidget.dart';
import 'package:autonomosapp/utility/InputValidator.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:autonomosapp/ui/widget/FormLayoutWidget.dart';

// TODO construir um bloc para esta tela!
class PerfilDetailsEditorScreen extends StatefulWidget {
  final UserRepository _repository = UserRepository();
  final _verticalSeparator = SizedBox(
    height: 16.0,
  );

  @override
  _PerfilDetailsEditorScreenState createState() =>
      _PerfilDetailsEditorScreenState();
}

class _PerfilDetailsEditorScreenState extends State<PerfilDetailsEditorScreen> {
  TextEditingController _nameInputController;
  FocusNode _nameInputFocus;
  CircularPictureWidgetBloc _circularWidgetBloc;
  TextEditingController _phoneFieldController;
  FocusNode _phoneFieldFocus;
  TextEditingController _descriptionFieldController;
  FocusNode _descriptionFieldFocus;
  ProgressBarHandler _handler;
  final GlobalKey<FormState> _formKey = GlobalKey();
  
  //TODO esse membro & demais regras devem ficar no Bloc desta tela!
  File _currentImageFile;

  @override
  void initState() {
    super.initState();
    _initTextFieldsSettings();

    _circularWidgetBloc = CircularPictureWidgetBloc(
      initialImageProvider: (widget._repository.currentUser.picturePath == null)
          ? AssetImage(Constants.ASSETS_LOGO_USER_PROFILE_FILE_NAME)
          : CachedNetworkImageProvider(
              widget._repository.currentUser.picturePath),
    );
  }

  void _initTextFieldsSettings() {
    _nameInputController =
        TextEditingController(text: widget._repository.currentUser.name);
    _nameInputFocus = FocusNode();

    _phoneFieldController = new MaskedTextController(
        mask: Constants.MASK_PHONE,
        text: widget._repository.currentUser.professionalData?.telefone);
    _phoneFieldFocus = FocusNode();

    _descriptionFieldController = TextEditingController(
        text: widget._repository.currentUser.professionalData?.descricao);
    _descriptionFieldFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    print("perfilDetailsEditorScreen build");
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 4.0,
            title: Text("Editar Perfil"),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
            child: _createBody(),
          ),
          bottomNavigationBar: RaisedButton(
              child: Text(
                "Confirmar",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
              onPressed: () async {
                if (_validation()) {
                  await _updateUserData();
                  Navigator.pop(context);
                }
              }),
        ),
        ModalRoundedProgressBar(
          handleCallback: (handler) {
            _handler = handler;
          },
        ),
      ],
    );
  }

  Widget _createBody() {
    List<Widget> widgetList = List();

    var userPicture = Column(
      children: <Widget>[
        Container(
          width: 140,
          height: 140,
          child: CircularEditablePictureWidget(
            bloc: _circularWidgetBloc,
            onClickCallback: () {
              _showModalBottomSheet();
            },
          ),
        ),
        Text("Clique para editar"),
      ],
    );

    var nameEditField = TextInputWidget(
      hint: "Nome",
      focusNode: _nameInputFocus,
      validator: InputValidator.nameValidation,
      controller: _nameInputController,
      textInputType: TextInputType.text,
      inputAction: TextInputAction.next,
      onFieldSubmitCallback: (dataTyped) {
        _changeFieldFocus(_nameInputFocus, _phoneFieldFocus);
      },
    );

    widgetList.add(nameEditField);

    if (widget._repository.currentUser.professionalData != null) {
      var phoneField = TextInputWidget(
        hint: "Telefone",
        focusNode: _phoneFieldFocus,
        validator: InputValidator.phoneValidation,
        textInputType: TextInputType.number,
        controller: _phoneFieldController,
        inputAction: TextInputAction.next,
        onFieldSubmitCallback: (dataTyped) {
          _changeFieldFocus(_phoneFieldFocus, _descriptionFieldFocus);
        },
      );

      widgetList.add(widget._verticalSeparator);
      widgetList.add(phoneField);
      widgetList.add(widget._verticalSeparator);

      var descriptionField = TextInputWidget(
        focusNode: _descriptionFieldFocus,
        maxLength: 48,
        maxLines: 4,
        validator: InputValidator.textDescription,
        controller: _descriptionFieldController,
        textInputType: TextInputType.text,
        inputAction: TextInputAction.done,
        onFieldSubmitCallback: (dataTyped) {
          _descriptionFieldFocus.unfocus();
        },
        decoration: InputDecoration(
          labelText: 'Decrição',
          labelStyle: TextStyle(
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );

      widgetList.add(descriptionField);
    }

    return ListView(
      children: <Widget>[
        userPicture,
        widget._verticalSeparator,
        FormLayoutWidget(formKey: _formKey, widgets: widgetList),
      ],
      shrinkWrap: true,
    );
  }

  @override
  void dispose() {
    _circularWidgetBloc?.dispose();
    _nameInputController?.dispose();
    _phoneFieldController?.dispose();
    _descriptionFieldController?.dispose();
    _descriptionFieldFocus?.dispose();
    _phoneFieldFocus?.dispose();
    _nameInputFocus?.dispose();
    super.dispose();
  }

  void _changeFieldFocus(FocusNode currentFocus, FocusNode newFocused) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(newFocused);
  }

  bool _validation() => _formKey.currentState.validate();

  void _showModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ChoosePictureBottomSheetWidget(
            onSelected: (pictureFile) {
              Navigator.pop(context);
              if (pictureFile != null) {
                _circularWidgetBloc.addToSink(
                  FileImage(pictureFile),
                );
                _currentImageFile = pictureFile;
              }
            },
          );
        });
  }

  //TEST metdo de testes!
  Future<void> _updateUserData() async {

    String url;
    var results;
    FirebaseUser fbUser;

    _handler.show(message: "Atualizando dados...");

    if (_currentImageFile != null) {
      url = await FirebaseStorageHelper.saveUserProfilePicture(
          picture: _currentImageFile,
          userUid: UserRepository().currentUser.uid);

      if (url != null)
        CachedNetworkImageProvider(url);
    }

    fbUser = await FirebaseAuth.instance.currentUser();
    results = await FirebaseUserHelper.updateFirebaseUserInfo(
        currentUser: fbUser,
        photoUrl: url,
        displayName: _nameInputController.text);

     if (results)
       fbUser = await FirebaseAuthHelper.reauthCurrentUser();

     var user = UserRepository().currentUser;
     user.picturePath = fbUser.photoUrl;
     user.name = fbUser.displayName;

    if (user.professionalData != null) {
      user.professionalData.descricao =
          _descriptionFieldController.text;
      user.professionalData.telefone =
          _phoneFieldController.text;

      FirebaseUserHelper.setUserProfessionalData(
        data: user.professionalData,
        uid: user.uid
      );
    }


    FirebaseUserHelper.updateUser(user: user);
    _handler.dismiss();
  }
}
