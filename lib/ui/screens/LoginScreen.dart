import 'package:autonos_app/model/ApplicationState.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/screens/UserRegisterScreen.dart';
import 'package:autonos_app/utility/InputValidator.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:autonos_app/ui/widget/ModalRoundedProgressBar.dart';
import 'package:autonos_app/ui/screens/MainScreen.dart';
import 'package:autonos_app/model/User.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autonos_app/utility/SharedPreferencesUtility.dart';
import 'package:autonos_app/firebase/FirebaseAuthHelper.dart';
import 'package:autonos_app/utility/Constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool iconVisibility = false;
  Icon icon = Icon(Icons.visibility_off);
  bool _obscureText = true;
  bool _rememberMe;
  FocusNode _emailFocus;
  FocusNode _passwordFocus;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _globalKey;
  ProgressBarHandler _handler;
  bool _autoValidate;
  var _email="", _password="";

  static final logo = Container(
    height: 140.0,
    child: DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Constants.ASSETS_LOGIN_LOGO_FILE_NAME),
            fit: BoxFit.scaleDown),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey();
    _autoValidate = false;
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();

      SharedPreferences prefs = UserRepository().preferences;

    _rememberMe = prefs.getBool(ApplicationState.KEY_REMEMBER_ME)?? false;
    if (_rememberMe) {
      _email = prefs.getString(ApplicationState.KEY_EMAIL);
      _password = prefs.getString(ApplicationState.KEY_PASSWORD);
    }

    _emailController = TextEditingController(text: _email);
    _passwordController = TextEditingController(text: _password);

  }

  void initiateFacebookLogin(BuildContext context) async {
    _handler.show();
    final facebookLogin = new FacebookLogin();

    final facebookLoginResult = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        _handler.dismiss();
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        _handler.dismiss();
        break;

      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        _handler.show(message: "Aguarde...");

        var resuls = await FirebaseAuthHelper.firebaseAuthWithFacebook(
            token: facebookLoginResult.accessToken.token);
        if (resuls){
          print("LOGADO COM SUCESSO");
          _gotoMainScreen(context, UserRepository().currentUser);
        }
        else {
          print("Login não aconteceu!");
          _handler.dismiss();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("LoginScreen::BuildMethod");
    return Scaffold(
      body: Center(
        child: Stack (
          children: _buildForm(),
        ),
      ),
    );
  }

  bool validate() {
    if (_globalKey.currentState.validate()) {
      setState(() {
        _email = _emailController.text;
        _password = _passwordController.text;
      });

      return true;
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
    return false;
  }

  void _gotoMainScreen(BuildContext context, User user) {

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
         // maintainState: true,
            builder: (BuildContext context) => MainScreen())
    );
  }

  void _showSnackBarErrorMessage(BuildContext ctx, String msg) {
    Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        )
    );
  }

  void cadastrar(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else
      Navigator.of(context)
          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return UserRegisterScreen();
      }));
  }

  List<Widget> _buildForm() {

    final emailField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: TextFormField(
          maxLines: 1,
          autofocus: false,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: _emailController,
          validator: InputValidator.emailValidation,
          focusNode: _emailFocus,
          onFieldSubmitted: (dataTyped) {
            _emailFocus.unfocus();
            FocusScope.of(context).requestFocus(_passwordFocus);
          },
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              labelText: "E-mail",
              suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(end: 12.0),
                child: IconButton(icon: Icon(Icons.email), onPressed: () {}),
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
          autofocus: false,
          obscureText: _obscureText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _passwordController,
          focusNode: _passwordFocus,
          onFieldSubmitted: (dataTyped) {
            _passwordFocus.unfocus();
          },
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              labelText: "Senha",
              suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(end: 12.0),
                child: IconButton(
                  onPressed: _toggle,
                  icon: icon,
                ),
              ),
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0))
          ),
        ),
      ),
    );


    final defaultTextStyle = TextStyle(
      inherit: false,
      color: Colors.black,
    );

    final rememberMe = Row(
      children: <Widget>[
        Checkbox(
            value: _rememberMe,
            tristate: false,
            onChanged: (status) {
              setState(() => _rememberMe = status );
            }),
        Text("Lembre-se de mim", style: defaultTextStyle,),
      ],
    );


    final forgotYourPassword = InkWell(
      splashColor: Colors.grey,
      onTap: (){},

      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.lock_open),
            Padding(padding: EdgeInsets.symmetric( horizontal: 2.0),) ,
            Text("Esqueceu a senha?",
              style: defaultTextStyle,
            ),
          ],
        ),
      ),
    );

    final userSupportLayout = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          rememberMe,
          forgotYourPassword,
        ],
      ),
    );

    final loginButton = Builder(builder: (BuildContext context){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(.0, 14.0, .0, 14.0),
          splashColor: Colors.redAccent,
          onPressed: () async {
            if (validate()) {
              _handler.show(message: "Aguarde...");
              var results = await FirebaseAuthHelper
                  .firebaseAuthWithEmailAndPassword( email:  _email, password: _password);
              switch( results ){
                case AuthResult.OK:
                  SharedPreferencesUtility.writePreferencesData(
                      email: _email, password: _password, rememberMe: _rememberMe);
                  _handler.dismiss();
                  _gotoMainScreen(context, UserRepository().currentUser);
                  break;

                case AuthResult.ERROR:
                  _handler.dismiss();
                  print("Erro desconhecido!!!");
                  break;

                case AuthResult.INVALID_USER:
                  _handler.dismiss();
                  _showSnackBarErrorMessage(context, "Usuário $_email não existe.");
                  break;

                case AuthResult.INVALID_PASSWORD:
                  _handler.dismiss();
                  _showSnackBarErrorMessage(context, "Senha inválida");
                  break;
              }
            }
          },
          color: Colors.red,
          child: Text(
            "Entrar",
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
      );
    } );



    final textPreRegisterButton = Container(
      padding: EdgeInsets.fromLTRB(16.0, .0, 2.0, .0),
      child: Text(
        'Ainda não possui uma conta?',
        style: TextStyle(
            fontSize: 12.0,
            fontStyle: FontStyle.italic,
            color: Colors.grey[500]
        ),
      ),
    );

    final registerButton = Flexible(
      child: FlatButton(
        onPressed: () {
          print("Realizar Cadastro");
          cadastrar(context);
        },
        splashColor: Colors.red,
        padding: EdgeInsets.fromLTRB(.0, .0, 16.0, .0),
        child: Text(
          "Cadastre-se",
          style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
        ),
        color: Colors.transparent,
      ),
    );


    final registerTextGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[textPreRegisterButton, registerButton],
    );

    final divisor1 = Expanded(
        child:Container(
          color: Colors.grey[300],
          height: 1.0,
          padding: EdgeInsets.fromLTRB(16.0, .0, .0, .0),
          margin: EdgeInsets.fromLTRB(16.0,.0, 8.0, .0),
        )
    );
    final divisor2 = Expanded(
        child: Container(
          color: Colors.grey[300],
          height: 1.0,
          padding: EdgeInsets.fromLTRB(.0, .0, 16.0, .0),

          margin: EdgeInsets.fromLTRB(8.0,.0, 16.0, .0),)
    );
    final divisor3 = Expanded(
        child: Container(
          color: Colors.grey[300],
          height: 1.0,
          padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, .0),

          margin: EdgeInsets.fromLTRB(16.0,.0, 16.0, .0),)
    );
    final divisor = Row(
      children: <Widget>[
        divisor3,
      ],
    );

    final divisiorOuGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        divisor1,
        Text('OU',style: TextStyle(color: Colors.grey[500]),),
        divisor2
      ],
    );
//    const IconData(59393, fontFamily: 'Facebook');
    final facebookLoginButton = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(.0, 14.0, .0, 14.0),
        child: Text(
          "Entrar com o Facebook",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Colors.blue[500],
        onPressed: () => initiateFacebookLogin(context),
      ),
    );

    var form = Form(
      key: _globalKey,
      autovalidate: _autoValidate,
      child: ListView(
        children: <Widget>[
          Constants.VERTICAL_SEPARATOR_16,
          logo,
          Constants.VERTICAL_SEPARATOR_16,
          emailField,
          Constants.VERTICAL_SEPARATOR_16,
          passwordField,
          userSupportLayout,
          Constants.VERTICAL_SEPARATOR_16,
          loginButton,
          Constants.VERTICAL_SEPARATOR_16,
          divisiorOuGroup,
          Constants.VERTICAL_SEPARATOR_16,
          facebookLoginButton,
          Constants.VERTICAL_SEPARATOR_16,
          divisor,
          registerTextGroup,
        ],
      ),
    );

    var progressBar = ModalRoundedProgressBar(
      handleCallback: ((handler){ _handler = handler; } ),);

    List<Widget> widgetList = new List();
    widgetList.add(form);
    widgetList.add( progressBar);

    return widgetList;
  }
} //end of class
