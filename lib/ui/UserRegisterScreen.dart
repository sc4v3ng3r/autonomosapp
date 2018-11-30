import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autonos_app/utility/InputValidator.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/MainScreen.dart';
import 'widget/ModalRoundedProgressBar.dart';


import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/model/Estado.dart';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:autonos_app/firebase/FirebaseStateCityHelper.dart';

//TODO olhar navegacao e rotas
// TODO ADICIONAR OS DEMAIS CAMPOS DE REGISTRO

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
  User _recentCreatedUser;

  DatabaseReference _userReference;
  static final RATING_INIT_VALUE = 5.0;

  static final SizedBox _verticalSeparator = new SizedBox(
    height: 16.0,
  );
  bool iconVisibility = false;
  Icon icon = Icon(Icons.visibility_off);
  bool _obscureText = true;
  var _email, _password, _name;
  var _passwordConfirmation;
  var _showProgressBar = false;

  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TEST button
  final testButton = MaterialButton(
    child: Text("Test Button"),
    color: Colors.green,
    onPressed: () {
      FirebaseStateCityHelper.getCityListByState("DF");

    },
  );

  @override
  void initState() {
    _nameFocus = new FocusNode();
    _emailFocus = new FocusNode();
    _passwordFocus = new FocusNode();
    _passwordConfirmFocus = new FocusNode();

    _nameController = new TextEditingController();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _passwordConfirmController = TextEditingController();
    _userReference = _userReference = FirebaseDatabase.instance.reference().child('usuarios');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    if (_formKey.currentState.validate()) {
      _name = _nameController.text;
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

  List<Widget> _buildForm() {
    //TODO nameField ainda estar sem validação de dados!
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
    final userphoto = Container(
      padding: EdgeInsets.fromLTRB(.0, 8.0, .0, .0),
      child: Image.asset(
        "assets/usuario.png",
        width: 168.0,height: 168.0,),
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
            print("Termo de uso pressionado");
          },
          child: Text("Temos de uso",
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
    final preTelaLogin = Container(

      child: Text("Já possui uma conta?" ,
        style: TextStyle(
            fontSize: 12.0,
            fontStyle: FontStyle.italic,
            color: Colors.grey[500]),),
    );
    final telaLogin = Flexible(
        child: FlatButton(
            padding: EdgeInsets.fromLTRB(2.0, .0, 16.0, .0),
            onPressed: (){
              Navigator.pop(context);
              print("voltar a tela de login pressionado");
            },
            child: Text("Faça login.",
              style: TextStyle(
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic),
            )
        )
    );
    final telaLoginGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        preTelaLogin,
        telaLogin
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
//        borderRadius: BorderRadius.circular(30.0),
        padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, .0),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, .0),
          splashColor: Colors.greenAccent,
          onPressed: () {

            if ( _inputValidation() == true ) {
              showProgressBar(true);

              _createUserAccount( _email,  _password).then(
                      (results) {
                        showProgressBar(false);
                        if (results) {
                          _showSnackBar(context, "Usuário registrado com sucesso!");
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (BuildContext context) =>
                                  MainScreen(user: _recentCreatedUser)),
                                  (Route<dynamic> route)  => false);
                        }
                        else // o usuario pode ja estar registrado ou dar erro na hora do registro!
                          _showSnackBar(
                              context, "Registro não realizado!", Colors.redAccent);
                      });
            }
          },
//          minWidth: 130.0,
          color: Colors.red,
          child: Text(
            "Confirmar",
            style: TextStyle(fontSize: 16.0,color: Colors.white),
          ),
        ),
      );
    });

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
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );

//    final buttonsGroup = Row(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        registerButton,
//        SizedBox(
//          width: 5.0,
//        ),
//        cancelButton
//      ],
//    );


    final form = Form(
      autovalidate: _autoValidate,
      key: _formKey,
      child: Container(
        color: Colors.white,
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
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
//            buttonsGroup
          registerButton,
            termosGroup,
            telaLoginGroup,
            testButton

          ],
        ),
      ),
    );

    var list = new List<Widget>();
    list.add(form);

    if ( _showProgressBar ) {
      var progressBar = ModalRoundedProgressBar();
      list.add(progressBar);
    }
    return list;
  }

  Future<bool> _createUserAccount( var email, var password ) async {

    bool returnFlag = false;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser;
    try {
      firebaseUser = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //print("FIREBASE USER: ${firebaseUser}"  );
      User userCreated = await _createAccountDBRegister(firebaseUser);

      returnFlag = true;
      //essa atribuicao deve mesmo ficar aqui??
      _recentCreatedUser = userCreated;
    }

    catch ( ex ){
      // NEsse caso aqui o usuario nao foi criado!
      print(ex.toString()  + " ${firebaseUser} " );
    }
    return returnFlag;
  }

  Future<User> _createAccountDBRegister(FirebaseUser recentCreatedUser) async {

    try {
      print("Registrando conta no DB!");
      User user = new User(
          recentCreatedUser.uid,
          _name, // dados do field name
          recentCreatedUser.email, RATING_INIT_VALUE);

      await _userReference.child(recentCreatedUser.uid)
          .set(user.toJson());

      return user;
    }

    catch ( ex ){

      print("Erro ao registar conta do Database");
      recentCreatedUser.delete()
          .then( (onValue) => FirebaseAuth.instance.signOut() )
          .catchError( (error) => print("UserRegisterScreen:: _createAccountDBRegister "
          + error.toString()));
    }
    return null;
  }


  /**Funca que foi utilizada p/ pegar dados do IBGE e popular nossa base do firebase*/
  /*
  static void _dataMining() async {

    FirebaseDatabase db = FirebaseDatabase.instance;
    DatabaseReference estadosRef = db.reference().child("estados");
    DatabaseReference cidadesReference = db.reference().child("estados_cidades");

    String uriEstados = "https://servicodados.ibge.gov.br/api/v1/localidades/estados/";
    var contentType = "application/json; charset=UTF-8";
    //List<Estado> estadoLista = new List();

    HttpClient client = new HttpClient();

    print("Making server request...");
    HttpClientRequest request = await client.getUrl(Uri.parse(uriEstados));
    print("setting headers");
    request.headers.set("Content-Type", contentType);

    print("Wating response...");
    HttpClientResponse response = await request.close();

    await for (var contents in response.transform(Utf8Decoder())) {
      List<dynamic> stateList = json.decode(contents);

      for (dynamic listItem in stateList) {
        // ou adiciona no firebase
        Estado estado = Estado.fromJson(listItem);
        estado.sigla = listItem["sigla"];
        String currentStateId = listItem["id"].toString();

        print("=====================================================================");
        print("$estado  ID: " + currentStateId);
        // insere estado no firebase
        await estadosRef.child(estado.sigla).set(estado.toJson());

        print("getting cities of ${estado.nome}");
        request = await client.getUrl(
            Uri.parse("$uriEstados $currentStateId/municipios"));
        request.headers.set("Content-Type", contentType);
        response = await request.close();

        await for (var content in (response.transform(Utf8Decoder()).transform(
            json.decoder))) {
          List<dynamic> jsonList = List.from(content);
          for (Map<String, dynamic> jsonData in jsonList) {
            Cidade city = Cidade.fromJson(jsonData); // obtem o nome,
            city.id = jsonData['id'];
            city.uf = estado.sigla; // sigla

            await cidadesReference.child( city.uf ).child(  city.id.toString() ).set( city.toJson() );
            //insere no firebase
            print(city);
          }
          print("=====================================================================\n");
        }
      }
    }
  }*/
  void showProgressBar(bool flag){
    setState(() {
      _showProgressBar = flag;
    });
  }

}
