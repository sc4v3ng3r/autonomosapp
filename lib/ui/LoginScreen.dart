import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'LoggedTESTScreen.dart';
//import 'package:autonos_app/cadastro_usuario.dart';
import 'UserRegisterScreen.dart';
import 'package:autonos_app/utility/InputValidator.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  GlobalKey<FormState> _globalKey = GlobalKey();
  bool _autoValidate = false;
  var _email, _password;

  @override
  void initState() {
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
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
//          validator: InputValidator.validadeEmail,
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
          onFieldSubmitted: (dataTyped){
            _passwordFocus.unfocus();
          },

          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),

          decoration: InputDecoration(
              labelText: "Senha",
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

              if (validate())
                logar(context);
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

    final forgotPassword = FlatButton(
        onPressed: () {
          print("Esqueceu a senha...");
        },
        color: Colors.transparent,
        child: Text(
          "Esqueceu a Senha?",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
    );

    return
    Scaffold(
     body: Container(
      child: Center(
        child: Form(
          key: _globalKey,
          autovalidate: _autoValidate,
          child:
            ListView(
              children: <Widget>[
              _VERTICAL_SEPARATOR,
              logo,
              _VERTICAL_SEPARATOR,
              emailField,
              _VERTICAL_SEPARATOR,
              passwordField,
              _VERTICAL_SEPARATOR,
              buttonGroup,
              forgotPassword
            ],
          ),
        ),
      ),
    ));
  }


  bool validate(){
    if (_globalKey.currentState.validate()){
      setState(() {
        _email = _emailController.text;
        _password = _passwordController.text;
      });
      return true;
    }

    else {
      setState(() {
        _autoValidate = true;
      });
    }

    return false;
  }

  // TODO esse metodo sera boolean
  void logar(BuildContext context) {

    /*FirebaseAuth auth = FirebaseAuth.instance;
    auth.linkWithEmailAndPassword(
        email: _email,
        password: _password).then((user){
          if (user == null){
            _showSnackBarInfo(context, "Login Inválido");
          } else {
            String msg = "Bem vindo ${user.displayName} ";
            _showSnackBarInfo(context, msg);
          }
        });
  */

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    else {
      Navigator.pushReplacementNamed(context, '/logedScreen');
    }
//      Navigator.of(context).pop();
//      Navigator.of(context)
//          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
//        return LoggedScreen();
//      }));}
  }

  void _showSnackBarInfo(BuildContext ctx, String msg){
    Scaffold.of(ctx).showSnackBar(
      SnackBar(content: Text(msg))
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


} // InputGroup
