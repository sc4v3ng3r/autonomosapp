import 'package:autonomosapp/firebase/FirebaseUserViewsHelper.dart';
import 'package:autonomosapp/model/Location.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/model/UserView.dart';
import 'package:autonomosapp/ui/screens/ProfessionalPerfilScreen.dart';
import 'package:autonomosapp/ui/widget/UserListItemWidget.dart';
import 'package:autonomosapp/utility/DateTimeUtility.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


/// Tela que exibe os profissionais encontrados numa busca em modo lista
class ProfessionalListScreen extends StatelessWidget {
  final List<User> _userList;
  final Location _location;

  ProfessionalListScreen({
    @required Location location,
    @required List<User> professionalList}) :
      _location = location,
      _userList = professionalList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profissionais"),
        brightness: Brightness.dark,
      ),

      body: ListView.builder(
          itemCount: _userList?.length ?? 0,
          itemBuilder: (context, index){
            var currentUser = _userList[index];
            return Card(
              elevation: 2.0,
              child: UserListItemWidget(
                distance: Geolocator().distanceBetween(
                    _location.latitude,
                    _location.longitude,
                    currentUser.professionalData.latitude,
                    currentUser.professionalData.longitude),
                user: currentUser,
                onTap: (){
                  _onTapUserCallback(context, _userList[index] );
                },
              ),
            );
          }),
    );
  }

  void _onTapUserCallback(BuildContext context, User user){
    _registerVisualization( user.uid );
    Navigator.push(  context, MaterialPageRoute(
        builder: (buildContext){
          return ProfessionalPerfilScreen( userProData: user, );
        }),
    );
  }

  /// TODO vai para o BLoC
  void _registerVisualization(final String proUid){
    Future<void>.delayed(Duration(seconds: 1), (){

      var uid = UserRepository.instance.currentUser.uid;
      if (proUid == uid)
        return;

      String date = DateTimeUtility.getCurrentDateString();

      var visualization = UserView(
          userVisitorId: uid,
          userVisualizedId: proUid,
          date: date
      );

      FirebaseUserViewsHelper.pushUserVisualization( viewData: visualization );
    } ).then((_) => print("Visualização Registrada"));
  }

}
