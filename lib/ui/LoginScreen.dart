import 'package:flutter/material.dart';
import 'LoggedScreen.dart';

//import 'package:autonos_app/cadastro_usuario.dart';
import 'UserRegisterScreen.dart';
import 'package:autonos_app/utility/InputValidator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// TODO tratar os FUTURES NA HORA DO LOGIN DA FORMA CORRETA!!
// TODO REALIZAR BUGFIX dos SNACKBARS
// TODO IMPLEMENTAR ROUNDED PROGRESS BAR
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
  var _email, _password;

  @override
  void initState() {
    _globalKey = GlobalKey();
    _autoValidate = false;
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }
  void initiateFacebookLogin() async {
    final facebookLogin = new FacebookLogin();
    final facebookLoginResult =
    await facebookLogin.logInWithReadPermissions(['email','public_profile']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        FirebaseAuth.instance.signInWithFacebook(accessToken: facebookLoginResult.accessToken.token);
        onLoginStatusChanged(true);
        break;
    }
  }

  void _firebaseAuthWithFacebook(final String token){
    print("FirebaseAuth -> Token:"+token);

  }

  bool isLoggedIn = false;

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      //padding: EdgeInsets.all(26.0),
      width: double.infinity,
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
              suffixIcon: Padding(padding: EdgeInsetsDirectional.only(end: 12.0),
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
                  borderRadius: BorderRadius.circular(22.0))),
        ),
      ),
    );

    final buttonGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            splashColor: Colors.yellowAccent,
            onPressed: () {
              if (validate()) logar(context);
            },
            minWidth: 130.0,
            color: Colors.green,
            child: Text(
              "Entrar",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        SizedBox(width: 5.0),
        Material(
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
        ),
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

    return new Scaffold(
        body: Container(
      child: Center(
        child: Form(
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
              RaisedButton(
                child: Text("Login with Facebook"),
                onPressed: () => initiateFacebookLogin(),
              ),
            ],
          ),
        ),
      ),
    ));
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

  // TODO esse metodo sera boolean
  void logar(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    //FirebaseUser user;

    print("EMAIL: $_email");
    print("SENHA: $_password");
    FirebaseUser currentUser = null;

    if (auth != null) {
      print("AUTH IS NOT NULL!!!!!!");
      auth.signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        String msg = "Bem vindo ${user.email} ";
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        else
          Navigator.pushReplacementNamed(context,'/logedScreen');
        //_showSnackBarInfo(context, msg);
      }).catchError((onError) {
        //_showSnackBarInfo(context, "Login Inválido");
      });
    }
    else {
      print("LASCOU & LASCOU!");
    }

    /*if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }else
    Navigator.pushReplacementNamed(context,'/logedScreen');
    */
  }


  void _showSnackBarInfo(BuildContext ctx, String msg) {
    Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
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
} // InputGroup
