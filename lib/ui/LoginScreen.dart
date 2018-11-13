import 'package:flutter/material.dart';
import 'UserRegisterScreen.dart';
import 'package:autonos_app/utility/InputValidator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'widget/ModalRoundedProgressBar.dart';
import 'package:autonos_app/firebase/FirebaseUserHelper.dart';
import 'LoggedScreen.dart';
import 'package:autonos_app/model/User.dart';

// TODO REALIZAR BUGFIX dos SNACKBARS
class LoginScreen extends StatefulWidget {
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SizedBox _VERTICAL_SEPARATOR = SizedBox(
    height: 16.0,
  );

  FocusNode _emailFocus;
  FocusNode _passwordFocus;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _globalKey;
  bool _autoValidate;
  bool _showProgressBar = false;
  var _email, _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      }).catchError( (dataBaseError) {

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
    }).catchError( (facebookError) {
      print(facebookError.toString());
      showProgressBar(false);
    });
  }

  List<Widget> _buildForm() {
    final logo = Container(
      height: 150.0,
      child: Center(
        child: Text(
          "Autônomos",
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            color: Colors.cyan,
            fontSize: 50.0,
            fontFamily: "cursive",
          ),
        ),
      ),
    );

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
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0))),
        ),
      ),
    );

    final passwordField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: TextFormField(
          maxLines: 1,
          autofocus: false,
          obscureText: true,
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
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {
                      print("eye clicked!");
                    }),
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

    final loginButton = Material(
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        splashColor: Colors.yellowAccent,
        onPressed: () {
          if (validate())
            firebaseLogin(context);
        },
        minWidth: 130.0,
        color: Colors.green,
        child: Text(
          "Entrar",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );

    final registerButton = Material(
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        splashColor: Colors.greenAccent,
        onPressed: () {
          print("realizar cadastro");
          cadastrar(context);
        },
        minWidth: 130.0,
        color: Colors.yellow,
        child: Text(
          "Cadastre-se",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );

    final buttonGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        loginButton,
        SizedBox(width: 5.0),// buttons separator
        registerButton,
      ],
    );

    final forgotPassword = Container(
      width: 150.0,
      child: FlatButton(
        onPressed: () {
          print("Esqueceu a senha...");
        },
        color: Colors.transparent,
        child: Text(
          "Esqueceu a Senha?",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final facebookLoginButton = RaisedButton(
      child: Text("Entrar com o Facebook"),
      onPressed: () => initiateFacebookLogin(context),
    );

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
          buttonGroup,
          forgotPassword,
          _VERTICAL_SEPARATOR,
          facebookLoginButton,
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
    return new Scaffold(
        body:Center(
          child: Stack(
            //overflow: Overflow.clip,
            children: _buildForm(),
          ),
        ),
    );
  }

  bool validate() {
    if ( _globalKey.currentState.validate() ) {
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

    auth.signInWithEmailAndPassword(email: _email, password: _password)
        .then((firebaseUser) {
      FirebaseUserHelper.readUserAccountData(firebaseUser.uid).then((user) {
        print("LIDO ${user.name}  ${user.email}");

        _goToLoggedScreen(context, user);

      }).catchError( (onError) {
        print(onError.toString());
        showProgressBar(false);
      });

    }).catchError( (firebaseError) {
      print(firebaseError.toString());
      showProgressBar(false);
    });
  }

  void _goToLoggedScreen(BuildContext context, User user){
    Navigator.pushReplacement(context, MaterialPageRoute
      (builder: (BuildContext context) => LoggedScreen( user:user )));
  }
  void _showSnackBarInfo(BuildContext ctx, String msg) {
    Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }

  void cadastrar(BuildContext context) {
    // POR ENQUANTO VOU DEIXAR ESSA NAVEGACAO MUITO LOUCA MESMO!
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    else
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
