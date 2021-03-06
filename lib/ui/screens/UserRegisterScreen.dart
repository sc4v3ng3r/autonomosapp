import 'dart:io';
import 'package:autonomosapp/firebase/FirebaseAuthHelper.dart';
import 'package:autonomosapp/firebase/FirebaseStorageHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/ui/widget/ChoosePictureBottomSheetWidget.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/SharedPreferencesUtility.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonomosapp/utility/InputValidator.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/screens/MainScreen.dart';
import 'package:autonomosapp/ui/widget/ModalRoundedProgressBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

// TODO metodos do firebase devem sair daqui
// TODO refatorar o layout
// TODO Componentizar os text fields

class UserRegisterScreen extends StatefulWidget {
  @override
  State createState() => UserRegisterScreenState();
}

class UserRegisterScreenState extends State<UserRegisterScreen> {
  FocusNode _nameFocus;
  TextEditingController _nameController;

  FocusNode _emailFocus;
  TextEditingController _emailController;
  FocusNode _passwordFocus;
  TextEditingController _passwordController;
  FocusNode _passwordConfirmFocus;
  TextEditingController _passwordConfirmController;
  ProgressBarHandler _handler;
  File _selectedUserImageFile;

  DatabaseReference _userReference;
  static const double RATING_INIT_VALUE = 5.0;

  static final SizedBox _verticalSeparator = new SizedBox(height: 16.0);
  bool iconVisibility = false;
  Icon icon = Icon(Icons.visibility_off);
  bool _obscureText = true;
  var _email, _password;

  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameFocus = new FocusNode();
    _emailFocus = new FocusNode();
    _passwordFocus = new FocusNode();
    _passwordConfirmFocus = new FocusNode();

    _nameController = new TextEditingController();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _passwordConfirmController = TextEditingController();
    //TODO vai sair!!
    _userReference = _userReference = FirebaseDatabase.instance.reference().child('usuarios');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(
        overflow: Overflow.clip,
        children: _buildForm(),
      ),
    );
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext ctx, String msg,
      [Color color = Colors.grey]) {
    var snack = SnackBar(
      content: Text(msg),
      backgroundColor: color,
    );

    Scaffold.of(ctx).showSnackBar(snack);
  }

  String _confirmPassword(String confirm) {
    final String msg = "Senhas incompatíveis";
    print("validating confirm");

    if (confirm == null || _passwordController.text == null)
      return msg;

    if (_passwordController.text.compareTo(confirm) != 0)
      return msg;

    return null;
  }

  bool _inputValidation() {
    if ( _formKey.currentState.validate() ) {
      //_name = _nameController.text;
      _email = _emailController.text;
      _password = _passwordController.text;
      return true;
      // REALIZA O CADASTRO!
    }

    // se ha dados invalidos, inicializamos
    // a validacao automatica!
    setState(() {
      _autoValidate = true;
    });
    return false;
  }

  List<Widget> _buildForm() {

    final nameField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: TextFormField(
          maxLines: 1,
          controller: _nameController,
          autofocus: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          focusNode: _nameFocus,
          validator: InputValidator.nameValidation,
          onFieldSubmitted: (dataTyped) {
            setState(() {
              _nameFocus.unfocus();
              FocusScope.of(context).requestFocus(_emailFocus);
            });
          },

          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),

          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: "Nome",
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0))),
        ),
      ),
    );

    final userphoto = Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Material(
            elevation: 8.0,
            color: Colors.transparent,
            child: Ink.image(
              width: 160.0,
              height: 160.0,
              image: (_selectedUserImageFile == null) ?  AssetImage("assets/usuario.png") :
              // TODO muito lento
              FileImage( _selectedUserImageFile),
              fit: BoxFit.cover,
              child: InkWell(
                onTap: (){
                  print("picture clicked");
                  //_selectPictureFromGallery();
                  _displayBottomSheet();
                },
              ),
            ),
          ),
        ),

        Constants.VERTICAL_SEPARATOR_8,

        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Toque para escolher sua foto",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );

    final emailField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: TextFormField(
          maxLines: 1,
          controller: _emailController,
          autofocus: false,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          focusNode: _emailFocus,
          validator: InputValidator.emailValidation,
          onFieldSubmitted: (dataTyped) {
            setState(() {
              _emailFocus.unfocus();
              FocusScope.of(context).requestFocus(_passwordFocus);
            });
          },
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: "E-mail",
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0)
              )
          ),
        ),
      ),
    );

    void _toggle(){
      setState(() {
        _obscureText = !_obscureText;
        iconVisibility = !iconVisibility;
        if(iconVisibility == false)
          icon = Icon(Icons.visibility_off);
        else
          icon = Icon(Icons.visibility);

      });
    }

    final passwordField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: TextFormField(
          maxLines: 1,
          controller: _passwordController,
          autofocus: false,
          obscureText: _obscureText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          focusNode: _passwordFocus,
          validator: InputValidator.passwordValidation,
          onFieldSubmitted: (dataTyped) {
            setState(() {
              _passwordFocus.unfocus();
              FocusScope.of(context).requestFocus(_passwordConfirmFocus);
            });
          },
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: "Senha",
              suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(end: 12.0),
                child: IconButton(
                    icon: icon,
                    onPressed: _toggle),
              ),
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0))),
        ),
      ),
    );
    final preTermosDeUso = Container(

      child: Text("Ao se cadastrar você concorda com os" ,
        style: TextStyle(
            fontSize: 12.0,
            fontStyle: FontStyle.italic,
            color: Colors.grey[500]),),
    );

    final termosDeUso = Flexible(
      child: FlatButton(
          padding: EdgeInsets.fromLTRB(2.0, .0, 16.0, .0),
          onPressed: (){
            _showUserTerms();
          },
          child: Text("Termos de uso",
            style: TextStyle(
                fontSize: 12.0,
                fontStyle: FontStyle.italic),
          )
      )
    );

    final termosGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        preTermosDeUso,
        termosDeUso
      ],
    );

    final passwordConfirm = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: TextFormField(
          maxLines: 1,
          controller: _passwordConfirmController,
          obscureText: true,
          autofocus: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          focusNode: _passwordConfirmFocus,
          validator: _confirmPassword,

          onFieldSubmitted: (dataTyped) {
            setState(() {
              _passwordConfirmFocus.unfocus();
            });
          },

          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),

          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: "Confirmar Senha",
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0))),
        ),
      ),
    );

    final registerButton = Builder(builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, .0),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, .0),
          splashColor: Colors.greenAccent,
          onPressed: () {

            if ( _inputValidation() == true ) {
              _handler.show();
              _createUserAccount( _email,  _password).then(
                      (results) {
                        _handler.dismiss();
                        if (results) {
                          _showSnackBar(context, "Usuário registrado com sucesso!");

                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MainScreen() ),
                                  (Route<dynamic> route)  => false);
                        }

                        else // o usuario pode ja estar registrado ou dar erro na hora do registro!
                          _showSnackBar(
                              context, "Registro não realizado!", Colors.redAccent);
                      });
            }
          },

          color: Colors.green,
          child: Text(
            "Confirmar",
            style: TextStyle(fontSize: 16.0,color: Colors.white),
          ),
        ),
      );
    });

    final backButton = Padding(
      padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, .0),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, .0),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.red,
        splashColor: Colors.redAccent,
        child: Text(
          "Voltar",
          style: TextStyle(fontSize: 16.0,color: Colors.white),
        ),
      ),
    );

    final form = Container(
        color: Colors.white,
        child: Padding(padding: EdgeInsetsDirectional.only(top: 16.0),
        child: Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              userphoto,
              _verticalSeparator,
              nameField,
              _verticalSeparator,
              emailField,
              _verticalSeparator,
              passwordField,
              _verticalSeparator,
              passwordConfirm,
              _verticalSeparator,
              termosGroup,
              registerButton,
              backButton,
            ],
          ),
        ),
        ),
    );

    var list = new List<Widget>();
    list.add(form);
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler){_handler = handler; },
    );

    list.add(progressBar);
    return list;
  }

  //TODO esse método DEVE sair desta classe
  Future<bool> _createUserAccount( var email, var password ) async {

    FirebaseUser firebaseUser = await FirebaseAuthHelper.createUserAccountWithEmailPassword(
          email: email, password: password);
    bool returnFlag = false;

    if (firebaseUser == null)
      return returnFlag;

    String pictureDownloadUrl;

    if ( _selectedUserImageFile?.path != null ){
      final StorageReference ref = FirebaseStorage.instance.ref()
          .child("${firebaseUser.uid}/${firebaseUser.email}${Constants.STORAGE_USER_PICTURE_FILE_NAME}");

      final StorageUploadTask uploadTask = ref.putFile(_selectedUserImageFile);
      final StorageTaskSnapshot snapshotTask = (await uploadTask.onComplete);
      pictureDownloadUrl = await snapshotTask.ref.getDownloadURL();

    }

    try{
      User userCreated = await _createAccountDBRegister(firebaseUser, pictureDownloadUrl );
      var repository = UserRepository();
      repository.currentUser = userCreated;
      repository.fbPassword = password;
      repository.fbLogin = email;

      SharedPreferencesUtility.writePreferencesData(
          email: email, password: password, rememberMe: true);

      returnFlag = true;
    }

    catch ( ex ){
      print(ex.toString()  + " ${firebaseUser} " );
    }
    return returnFlag;
  }

  //TODO esse método DEVE sair desta classe
  Future<User> _createAccountDBRegister(FirebaseUser recentCreatedUser, String pictureUrl) async {

    try {
      var name = recentCreatedUser.displayName;
      print("Registrando conta no DB!");
      if (name == null)
        name = _nameController.text;

      User user = new User(
          uid: recentCreatedUser.uid,
          email: recentCreatedUser.email,
          name: name,
          picturePath: pictureUrl,
          rating: RATING_INIT_VALUE);

      await _userReference.child(recentCreatedUser.uid)
          .set(user.toJson());

      await FirebaseUserHelper.updateFirebaseUserInfo( currentUser: recentCreatedUser,
        displayName: name, photoUrl: pictureUrl, );
      return user;
    }

    catch ( ex ){
      print("Erro ao registar conta do Database");
      recentCreatedUser.delete()
          .then( (_) => FirebaseAuth.instance.signOut() )
          .catchError( (error) => print("UserRegisterScreen:: _createAccountDBRegister "
          + error.toString()));
    }
    return null;
  }

  void _displayBottomSheet(){
    showModalBottomSheet(context: context, builder: (buildContext) {
      return ChoosePictureBottomSheetWidget(
        onSelected: (path){
          if (path != null) {
            Navigator.pop(buildContext);
            setState(() {
              _selectedUserImageFile = path;
            });
          } else Navigator.pop( buildContext );
        },
      );
    });
  }

  void _showUserTerms() async {

    _handler.show(message: 'Carregando Termo de uso');
    try{
      File file = await FirebaseStorageHelper.getUserTermFile();
      if (file != null)
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => PDFViewerScaffold(path: file.path))
        );
      _handler.dismiss();
    }
    catch (ex){
      _handler.dismiss();
    }


  }
}
