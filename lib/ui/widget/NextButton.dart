import 'package:flutter/material.dart';

//TODO ESSE WIDGET PODE SER STATELESS
class NextButton extends StatefulWidget {

  final String _text;
  final Color _buttonColor;
  final Color _textColor;
  final Function _callback;

  NextButton( { String text = "Button", Color textColor = Colors.white,
                Color buttonColor = Colors.green,  @required Function callback} ) :
        _text = text,
        _textColor = textColor,
        _buttonColor = buttonColor,
        _callback = callback;

  @override
  State createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        padding: EdgeInsets.fromLTRB(.0, 8.0, .0, 8.0),
        onPressed: this.widget._callback,
        color: this.widget._buttonColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget._text,
                style: TextStyle(color: widget._textColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.directions_run, color: Colors.white,),
            ),
          ],
        ),
    );
  }

}