import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRegisterScreen extends StatefulWidget{

  @override
  State createState() => UserRegisterScreenState();

}

class UserRegisterScreenState extends State<UserRegisterScreen>{
  FocusNode _emailFocus;
  TextEditingController _emailController;
  FocusNode _passwordFocus;
  TextEditingController _passwordController;
  FocusNode _passwordConfirmFocus;
  TextEditingController _confirmController;
  final SizedBox _verticalSeparator = new SizedBox(height: 24.0,);
  var email, password;
  var passwordConf;

  @override
  void initState() {
    _emailFocus = new FocusNode();
    _passwordFocus = new FocusNode();
    _passwordConfirmFocus = new FocusNode();

    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

          onEditingComplete: () {
            setState(() {
              email = _emailController.text;
            });

            print("EMail field: $email");
          },
          onFieldSubmitted: (dataTyped) {
            print(dataTyped);
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
              border:
              OutlineInputBorder( borderRadius: BorderRadius.circular(22.0)) ),
        ),
      ),
    );

    final passwordField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: TextFormField(
          maxLines: 1,
          controller: _passwordController,
          onEditingComplete: (){
            setState(() {
              password = _passwordController.text;
            });

            print("Password Field: $password");
          },
          autofocus: false,
          obscureText: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          focusNode: _passwordFocus,
          onFieldSubmitted: (dataTyped){
            _passwordFocus.unfocus();
            FocusScope.of(context).requestFocus(_passwordConfirmFocus);
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
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(22.0))
          ),
        ),
      ),
    );

    final passwordConfirm = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: TextFormField(
          maxLines: 1,
          controller: _confirmController,
          onEditingComplete: () {
            setState(() {
              passwordConf = _confirmController.text;
            });
            print("Confirm Field: $passwordConf");
          },
          obscureText: true,
          autofocus: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          focusNode: _passwordConfirmFocus,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),

          decoration: InputDecoration(
              labelText: "Confirmar Senha",
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(22.0))
          ),
        ),
      ),
    );

    final registerButton = Material(
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        splashColor: Colors.greenAccent,
        onPressed: () {
          print("Email: $email " );
          print("Senha: $password");
          print("Confirmacao: $passwordConf");

          FirebaseAuth auth = FirebaseAuth.instance;
          auth.createUserWithEmailAndPassword(email: email,
              password: password).then((firebaseUser){
                print ("Registrado: ${firebaseUser.email}  ${firebaseUser.uid}");
          });
        
        },

        minWidth: 130.0,
        color: Colors.yellow,
        child: Text(
          "Confirmar",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );

    final cancelButton = Material(
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        splashColor: Colors.red,
        onPressed: () {
          print("cancelar cadastro");
          Navigator.pop(context);
        },

        minWidth: 130.0,
        color: Colors.redAccent,
        child: Text(
          "Cancelar",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, color: Colors.white,),
        ),
      ),
    );

    final buttonsGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        registerButton,
        SizedBox(width: 5.0,),
        cancelButton
      ],
    );

    return
      Scaffold(
        appBar: AppBar(
          title: Text("Registrar"),

        ),
        body:
        Container(
          padding: EdgeInsets.only(top: 24.0),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                emailField,
                _verticalSeparator,
                passwordField,
                _verticalSeparator,
                passwordConfirm,
                _verticalSeparator,
                buttonsGroup
              ],
            ),
            /*child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                emailField,
                _verticalSeparator,
                passwordField,
                _verticalSeparator,
                passwordConfirm,
                _verticalSeparator,
                buttonsGroup
              ],
            ),*/
          ),
        ),

      );

  }
}