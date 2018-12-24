import 'package:autonos_app/firebase/FirebaseUserHelper.dart';
import 'package:autonos_app/model/User.dart';
import 'package:autonos_app/ui/screens/ui_perfil_usuario/PerfilUsuarioComumScreen.dart';
import 'package:autonos_app/ui/screens/ui_perfil_usuario/PerfilUsuarioProfissional.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:flutter/material.dart';

class PerfilUsuarioScreen extends StatelessWidget {

  choiceScreen(User user) {
    bool _isProfissional = false;

    if (user.professionalData != null)
      _isProfissional = true;
    else
      _isProfissional = false;

    if (user != null) {
      return _isProfissional == true
          ? PerfilUsuarioProfissionalScreen(user: user)
          : PerfilUsuarioComumScreen(user: user);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: FirebaseUserHelper.currentLoggedUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
//            return _progressBarHandler.show();
          case ConnectionState.active:
//            return _progressBarHandler.show();
          case ConnectionState.waiting:
            print("STATE ${snapshot.connectionState.toString()}");
            return Stack();

          //TODO MELHORAR ESSA VERIFICACAO!
          case ConnectionState.done:
            print("STATE ${snapshot.connectionState.toString()}");
            print("Snapshot:  ${snapshot.data} ");

            if (snapshot.data != null) {
              UserRepository().currentUser = snapshot.data;
              return Container(
                child: choiceScreen(UserRepository().currentUser),
              );
            }
        }
      },
    );
  }
}
