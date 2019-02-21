import 'package:autonomosapp/ui/screens/LoginScreen.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/screens/MainScreen.dart';
import 'package:rxdart/rxdart.dart';
// Marcelo
/*(71)991259223*/
void main() {
  runApp( new MyApp() );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyAppBloc _bloc;

  @override
  void initState() {
    _bloc = MyAppBloc();
    super.initState();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Autônomos",

      home: (UserRepository.instance.currentUser == null) ? StreamBuilder<User>(
        stream: _bloc.getCurrentUser,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Material(
                color: Colors.grey[350],
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                  ],
                ),
              );

            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData){
                return MainScreen();
              }
              return LoginScreen();
              //break;
          }
        },
      ) : MainScreen(),

      theme: ThemeData(
        primaryColor: Colors.amber,
        accentColor: Colors.black,
        errorColor: Colors.red,
        cursorColor: Colors.black,
        textSelectionHandleColor: Colors.black,
      ),
    );
  }
}


class MyAppBloc {

  UserRepository _repository;
  final PublishSubject<User> _userSubject = PublishSubject();
  Observable<User> get getCurrentUser =>_userSubject.stream;

  MyAppBloc(){

    if (UserRepository.instance.currentUser == null){
      FirebaseUserHelper.currentLoggedUser()
          .timeout( Duration(seconds: Constants.NETWORK_TIMEOUT_SECONDS),
          onTimeout: () {
            _repository = UserRepository.instance;
            _repository.currentUser = null;
            _addToSink( _repository.currentUser );
          }
          ).then( (user){
            _repository = UserRepository.instance;
            _repository.currentUser = user;
            _addToSink(user);
          } ).catchError((error) { print("MyAppBloc::Constructor $error"); _addToSink(null); });
    } else _addToSink( _repository.currentUser );
  }

  void _addToSink(final User user) => _userSubject.add( user );

  dispose(){
    _userSubject?.close();
  }
}