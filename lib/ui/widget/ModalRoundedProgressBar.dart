import 'package:flutter/material.dart';

class ModalRoundedProgressBar extends StatefulWidget {
  final double _opacity;
  final Color _color;
  final Function _handlerCallback;

  ModalRoundedProgressBar({
    @required Function handleCallback(ProgressBarHandler handler),
    double opacity = 0.7,
    Color color = Colors.black54,
  })  : _opacity = opacity,
        _color = color,
        _handlerCallback = handleCallback;

  @override
  State createState() => _ModalRoundedProgressBarState();
}

class _ModalRoundedProgressBarState extends State<ModalRoundedProgressBar> {
  bool _isShowing = false;
  String _message = "";

  @override
  void initState() {
    super.initState();
    ProgressBarHandler handler = ProgressBarHandler();
    handler.show = this.show;
    handler.dismiss = this.dismiss;
    handler.changeMessage = this.message;
    widget._handlerCallback(handler);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShowing) return Stack();

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: widget._opacity,
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
                Text(_message),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void show({String message=""}) {
    setState(() {
      _message = message;
      _isShowing = true;
    });

  }

  void dismiss() {
    setState(() => _isShowing = false);
  }

  void message(String message){
    setState(() { _message = message; });
  }
}

class ProgressBarHandler {
  Function show;
  Function dismiss;
  Function changeMessage;
}
