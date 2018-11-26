import 'package:flutter/material.dart';
import 'UserRegisterScreen.dart';
import 'package:autonos_app/utility/InputValidator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'widget/ModalRoundedProgressBar.dart';
import 'package:autonos_app/firebase/FirebaseUserHelper.dart';
import 'MainScreen.dart';
import 'package:autonos_app/model/User.dart';
import 'package:flutter/services.dart';

// TODO REALIZAR BUGFIX dos SNACKBARS
class LoginScreen extends StatefulWidget {
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SizedBox _VERTICAL_SEPARATOR = SizedBox(
    height: 16.0,
  );

  bool iconVisibility = false;
  Icon icon = Icon(Icons.visibility_off);
  bool _obscureText = true;
  FocusNode _emailFocus;
  FocusNode _passwordFocus;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _globalKey;
  bool _autoValidate;
  bool _showProgressBar = false;
  var _email, _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final logo = Container(
    height: 140.0,
    child: DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/login_logo_name.png"), fit: BoxFit.scaleDown),
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
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void initiateFacebookLogin(BuildContext context) async {
    showProgressBar(true);
    final facebookLogin = new FacebookLogin();
    final facebookLoginResult = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        showProgressBar(false);
        //onLoginStatusChanged(false);
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        showProgressBar(false);
        //onLoginStatusChanged(false);
        break;

      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        firebaseAuthWithFacebook(
            facebookLoginResult.accessToken.token, context);
        
        //onLoginStatusChanged(true);
        //print("login status changed!");
        break;
    }
  }

  void firebaseAuthWithFacebook(final String token, BuildContext context) {
    print("FirebaseAuth -> Token:" + token);
    _auth.signInWithFacebook(accessToken: token).then((firebaseUser) {
      FirebaseUserHelper.readUserAccountData(firebaseUser.uid).then((user) {
        print("LIDO COM FACEBOOK ${user.email} ${user.name}");

        _goToLoggedScreen(context, user);
      }).catchError((dataBaseError) {
        FirebaseUserHelper.writeUserAccountData(firebaseUser)
            .then((createdUser) {
          print("USUARIO CRIADO COM SUCESSO!");
          print("CREATED: ${createdUser.name}  ${createdUser.email}");

          _goToLoggedScreen(context, createdUser);
        }).catchError((error) {
          print("ERRO AO CRIAR USUARIO NO DB COM FACEBOOK!");
          print(error.toString());
          showProgressBar(false);
        });
      });
    }).catchError((facebookError) {
      print(facebookError.toString());
      showProgressBar(false);
    });
  }

  List<Widget> _buildForm() {

        /*child: Text(
          "Autônomos",
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            color: Colors.red,
            fontSize: 50.0,
            fontFamily: "cursive",
          ),
        ),*/
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
                  borderRadius: BorderRadius.circular(22.0))),
        ),
      ),
    );

    final loginButton = Padding(
//      borderRadius: BorderRadius.circular(200.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(.0, 14.0, .0, 14.0),
//        minWidth: MediaQuery.of(context).size.width,
        splashColor: Colors.yellowAccent,
        onPressed: () {
          if (validate()) firebaseLogin(context);
        },
//        minWidth: 130.0,
//      borderSide: BorderSide(style: BorderStyle.solid),
        color: Colors.redAccent,
        child: Text(
          "Entrar",
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
    final textPreRegisterButton = Container(
      padding: EdgeInsets.fromLTRB(16.0, .0, 2.0, .0),
      child: Text(
        'Ainda não possui uma conta?',
        style: TextStyle(
        fontSize: 12.0,
        fontStyle: FontStyle.italic,
        color: Colors.grey[500]),
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

    final preForgotPassword = Container(
      padding: EdgeInsets.fromLTRB(16.0, .0, 5.0, .0),
      child: Text(
        "Não lembra do login/senha?",
        style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 12.0,
            color: Colors.grey[500]),
        overflow: TextOverflow.clip,
      ),
    );
    final forgotPassword = Flexible(
      child: FlatButton(
        padding: EdgeInsets.fromLTRB(.0, .0, 16.0, .0),
        onPressed: () {
          print("Esqueceu a senha...");
        },
        color: Colors.transparent,
        child: Text(
          "Recupere seus dados.",
          style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
//          overflow: TextOverflow.fade,
        ),
      ),
    );
    final forgotGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[preForgotPassword, forgotPassword],
    );
    final registerTextGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[textPreRegisterButton, registerButton],
    );
    final buttonsGroupAux = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[registerButton, forgotPassword],
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
        divisor3
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
              fontWeight: FontWeight.bold
                ),
          ),
          color: Colors.blue[500],
          onPressed: () => initiateFacebookLogin(context),
        ));

    var form = Form(
      key: _globalKey,
      autovalidate: _autoValidate,
      child: ListView(
        children: <Widget>[
          _VERTICAL_SEPARATOR,
          logo,
          _VERTICAL_SEPARATOR,
          emailField,
          _VERTICAL_SEPARATOR,
          passwordField,
          _VERTICAL_SEPARATOR,
          _VERTICAL_SEPARATOR,
          loginButton,
          _VERTICAL_SEPARATOR,
          forgotGroup,
          divisiorOuGroup,
          _VERTICAL_SEPARATOR,
          facebookLoginButton,
          _VERTICAL_SEPARATOR,
          divisor,
          registerTextGroup,
        ],
      ),
    );

    List<Widget> widgetList = new List();
    widgetList.add(form);

    if (_showProgressBar == true) widgetList.add(new ModalRoundedProgressBar());

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    print("LoginScreen::BuildMethod");
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      systemNavigationBarColor: Colors.red,
//      statusBarColor: Colors.red[600],
//    ));
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return new Scaffold(
//      bottomNavigationBar: BottomNavigationBar(items: null,fixedColor: Colors.red,),
      body: Center(
        child: Stack(
          //overflow: Overflow.clip,
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

  void firebaseLogin(BuildContext context) {
    showProgressBar(true);
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((firebaseUser) {
      FirebaseUserHelper.readUserAccountData(firebaseUser.uid).then((user) {
        print("LIDO ${user.name}  ${user.email}");

        _goToLoggedScreen(context, user);
      }).catchError((onError) {
        print(onError.toString());
        showProgressBar(false);
      });
    }).catchError((firebaseError) {
      print(firebaseError.toString());
      showProgressBar(false);
    });
  }

  void _goToLoggedScreen(BuildContext context, User user) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(user: user)));
  }

  void _showSnackBarInfo(BuildContext ctx, String msg) {
    Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }

  void cadastrar(BuildContext context) {
    // POR ENQUANTO VOU DEIXAR ESSA NAVEGACAO MUITO LOUCA MESMO!
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else
      Navigator.of(context)
          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return UserRegisterScreen();
      }));
  }

  void showProgressBar(bool flag) {
    setState(() {
      _showProgressBar = flag;
    });
  }
} //end of class
