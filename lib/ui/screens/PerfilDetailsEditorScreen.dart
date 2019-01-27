import 'package:autonos_app/ui/widget/ChoosePictureBottomSheetWidget.dart';
import 'package:autonos_app/utility/Constants.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/widget/TextInputWidget.dart';
import 'package:autonos_app/ui/widget/CircularPictureWidget.dart';
import 'package:autonos_app/utility/InputValidator.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:autonos_app/ui/widget/FormLayoutWidget.dart';

class PerfilDetailsEditorScreen extends StatefulWidget {
  final UserRepository _repository = UserRepository();
  final _verticalSeparator = SizedBox(height: 16.0,);

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
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initTextFieldsSettings();

    _circularWidgetBloc = CircularPictureWidgetBloc(
      initialImageProvider: (widget._repository.imageUrl == null)
        ? AssetImage("assets/usuario.png")
        : CachedNetworkImageProvider(widget._repository.imageUrl),
    );
  }

  void _initTextFieldsSettings(){
    _nameInputController = TextEditingController( text: widget._repository.currentUser.name );
    _nameInputFocus = FocusNode();

    _phoneFieldController = new MaskedTextController(mask: Constants.MASK_PHONE,
        text: widget._repository.currentUser.professionalData?.telefone);
    _phoneFieldFocus = FocusNode();

    _descriptionFieldController = TextEditingController(
        text: widget._repository.currentUser.professionalData?.descricao);
    _descriptionFieldFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    print("perfilDetailsEditorScreen build");
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        title: Text("Editar Perfil"),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
        child: _createBody(),
      ),

      bottomNavigationBar: RaisedButton(
        child: Text("Confirmar",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        color: Colors.green,
        onPressed: (){
          _validation();
        }),
    );
  }

  Widget _createBody(){
    List<Widget> widgetList = List();

    var userPicture = Column(
      children: <Widget>[
        Container(
            width: 140,
            height: 140,
            child: CircularEditablePictureWidget(
              bloc: _circularWidgetBloc,
              onClickCallback: (){
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
      onFieldSubmitCallback: (dataTyped){
        _changeFieldFocus(_nameInputFocus, _phoneFieldFocus);
      },
    );

    widgetList.add( nameEditField );

    if (widget._repository.currentUser.professionalData != null){

      var phoneField = TextInputWidget(
        hint: "Telefone",
        focusNode: _phoneFieldFocus,
        validator: InputValidator.phoneValidation,
        textInputType: TextInputType.number,
        controller: _phoneFieldController,
        inputAction: TextInputAction.next,
        onFieldSubmitCallback: (dataTyped){
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
        onFieldSubmitCallback: (dataTyped) { _descriptionFieldFocus.unfocus(); },
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

      widgetList.add( descriptionField );
    }

    return ListView(
        children: <Widget>[
          userPicture,
          widget._verticalSeparator,
          FormLayoutWidget(
              formKey: _formKey,
              widgets: widgetList
          ),
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

  void _changeFieldFocus(FocusNode currentFocus, FocusNode newFocused ){
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(newFocused);
  }

  bool _validation() => _formKey.currentState.validate();

  void _showModalBottomSheet() {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return ChoosePictureBottomSheetWidget(
        onSelected: (pictureFile){
          Navigator.pop(context);
          if (pictureFile!=null)
            _circularWidgetBloc.addToSink( FileImage(pictureFile ) );
        },
      );
    });
  }
}
