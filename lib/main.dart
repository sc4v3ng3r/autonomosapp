import 'package:autonomosapp/ui/screens/LoginScreen.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/LocationUtility.dart';
import 'package:autonomosapp/utility/PermissionUtiliy.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/screens/MainScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

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

      home: StreamBuilder<User>(
        stream: _bloc.getCurrentUser,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                child: Center(
                  child: ImageRotateAnimation(
                    imagePath: Constants.ASSETS_ANIMATION_LOGO,
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage( Constants.ASSETS_ANIMATION_BACKGROUND ),
                    fit: BoxFit.fill,
                  ),
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
      ),

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


  void _updateUserLocation(){
    print("updating user position");
    PermissionUtility.hasLocationPermission().then(
            (status){

              if (status){
                LocationUtility.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high ).then(
                        (position){
                          User user = _repository.currentUser;
                          print("USER: ${user.name}");
                          user.professionalData.latitude = position.latitude;
                          user.professionalData.longitude = position.longitude;
                          print("updating location: LA: ${position.latitude} | LO: ${position.longitude}");
                          FirebaseUserHelper.updateUser(user: user);

                        } );
              }
        }
    );
  }


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
            
            if (user.professionalData != null){
              _updateUserLocation();
            }

          } ).catchError((error) { print("MyAppBloc::Constructor $error"); _addToSink(null); });
    } else _addToSink( _repository.currentUser );
    
  }

  void _addToSink(final User user) => _userSubject.add( user );

  dispose(){
    _userSubject?.close();
  }
}

class ImageRotateAnimation extends StatefulWidget {

  final String _imagePath;
  ImageRotateAnimation( {@required String imagePath} ) : _imagePath = imagePath;

  @override
  _ImageRotateAnimationState createState() => new _ImageRotateAnimationState();
}

class _ImageRotateAnimationState extends State<ImageRotateAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    animationController.repeat();
  }


  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: new AnimatedBuilder(
        animation: animationController,
        child: Container(
          width: 280.0,
          height: 288.0,
          child: Image.asset(widget._imagePath ),
        ),
        builder: (BuildContext context, Widget _widget) {
          return Transform.rotate(
            angle: animationController.value * 6.3,
            child: _widget,
          );
        },
      ),
    );
  }
}