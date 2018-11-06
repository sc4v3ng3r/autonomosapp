import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonos_app/utility/InputValidator.dart';

class UserRegisterScreen extends StatefulWidget{

  @override
  State createState() => UserRegisterScreenState();

}

class UserRegisterScreenState extends State<UserRegisterScreen> {

  FocusNode _emailFocus;
  TextEditingController _emailController;
  FocusNode _passwordFocus;
  TextEditingController _passwordController;
  FocusNode _passwordConfirmFocus;
  TextEditingController _passwordConfirmController;

  final SizedBox _verticalSeparator = new SizedBox(height: 24.0,);

  var _email, _password;
  var _passwordConfirmation;

  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailFocus = new FocusNode();
    _passwordFocus = new FocusNode();
    _passwordConfirmFocus = new FocusNode();

    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _passwordConfirmController = TextEditingController();
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

          validator: InputValidator.validadeEmail,
          /*
          onSaved: (String emailValid){
            setState(() {
              _email = emailValid;
            });

          },*/

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
              labelText: "E-mail",
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),

              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder( borderRadius: BorderRadius.circular(22.0))
          ),
        ),
      ),
    );

    final passwordField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(

        child: TextFormField(
          maxLines: 1,
          controller: _passwordController,
          autofocus: false,
          obscureText: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          focusNode: _passwordFocus,

          validator: InputValidator.validadePassword,

          /*
          onSaved: (passwordValid) {
            setState(() {
              _password = passwordValid;
            });

            print("password valid: $_password");
          },*/

          onFieldSubmitted: (dataTyped){
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
          controller: _passwordConfirmController,
          obscureText: true,
          autofocus: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          focusNode: _passwordConfirmFocus,
          validator: _confirmPassword,

          /*
          onSaved: (confirmOk) {
            setState(() {
              _passwordConf = confirmOk;
            });
            //print("password: $_password Confirmation: $_passwordConf");
          },*/

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

    final registerButton = Builder (
        builder: (BuildContext context){
          return Material(
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(
              splashColor: Colors.greenAccent,
              onPressed: () {
                if ( _validadeInput() == true ){
                  FirebaseAuth auth = FirebaseAuth.instance;

                  auth.createUserWithEmailAndPassword(
                      email: _email,
                      password: _password).then(
                          (firebaseUser){
                        if (firebaseUser == null){
                          _showSnackBar(context, "Usuário não registrado!");
                          print ("Registrado: ${firebaseUser.email}  ${firebaseUser.uid}");
                        }

                        else {
                          _showSnackBar(context, "Usuário registrado!");
                        }

                      }).catchError((onError) {
                    print(onError.toString());
                  });
                }
              },

              minWidth: 130.0,
              color: Colors.yellow,
              child: Text(
                "Confirmar",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          );
        }
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
            child: Form(
              autovalidate: _autoValidate,
              key: _formKey,
              child:
              ListView(
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
            ),
          ),
        ),

      );
  }

  void _showSnackBar(BuildContext ctx, String msg){
    var snack = SnackBar(
      content: Text(msg),
    );

    Scaffold.of(ctx).showSnackBar( snack );
  }

  String _confirmPassword(String confirm){
    final String msg = "Senhas incompatíveis";
    print("validating confirm");
    if (confirm == null || _passwordController.text == null )
      return msg;

    if (_passwordController.text.compareTo(confirm) != 0)
      return msg;

    return null;
  }

  bool _validadeInput(){
    if (_formKey.currentState.validate() ){
      _email = _emailController.text;
      _password = _passwordController.text;
      _passwordConfirmation = _passwordConfirmController.text;
      /*nao vou usaro onsave, vou para uma abordagem manual!*/
      //formKey.currentState.save();
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
}