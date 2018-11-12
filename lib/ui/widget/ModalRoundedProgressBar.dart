import 'package:flutter/material.dart';

/**
 * Apesar de ser StatefulWidget ainda nao ha interace para mudar seu estado!!
 * Entretando, a estrutura ja estar pronta para realizar mudancas de texto & cor
 * durante a execucao e exibicao!
 */
class ModalRoundedProgressBar extends StatefulWidget {
  @override
  State createState() => _ModalRoundedProgressBarState();
}

class _ModalRoundedProgressBarState extends State<ModalRoundedProgressBar> {
  // String _textMessage;

  /* ModalRoundedProgressBarState( {String message =""} ) :
      _textMessage = message;
      */
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.7,
          child: ModalBarrier(
            dismissible: false,
            color: Colors.black54,
          ),
        ),

        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              //Text("Registrando"),
            ],
          ),
        ),
      ],
    );
  }
}
