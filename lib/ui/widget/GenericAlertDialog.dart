import 'package:flutter/material.dart';

class GenericAlertDialog extends StatelessWidget {

  final Widget _positiveButtonContent;
  final Widget _negativeButtonContent;
  final String _title;
  final Widget _content;

  GenericAlertDialog({String title = "Title",
    Widget content = const Text("Alert dialog content"),
    Widget negativeButtonContent =const Text("Cancelar"),
    Widget positiveButtonContent = const Text("Confirmar")}) :
      _title = title,
      _content = content,
      _positiveButtonContent = positiveButtonContent,
      _negativeButtonContent = negativeButtonContent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: SingleChildScrollView(
        child: _content,
      ),
      actions: <Widget>[
        FlatButton(
          child: _negativeButtonContent,
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        ),

        FlatButton(
          child: _positiveButtonContent,
          onPressed: (){
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}