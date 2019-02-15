import 'package:flutter/material.dart';

class EditableButton extends StatefulWidget {

  final Function _onPressed;
  final Function _callback;
  final Color _color;
  final Color _textColor;
  String _secondaryText;
  String _primaryText;

  EditableButton({@required Function onPressed,
    @required controllerCallback(EditableButtonController controller),
    Color backgroundColor, Color textColor, String primaryText = "", String secondaryText = ""}) :
      _onPressed = onPressed,
      _primaryText = primaryText,
      _secondaryText = secondaryText,
      _textColor = textColor,
      _color = backgroundColor,
      _callback = controllerCallback;

  @override
  _EditableButtonState createState() => _EditableButtonState();
}

class _EditableButtonState extends State<EditableButton> {

  String _secondName;

  @override
  void initState() {
    super.initState();
    _secondName = widget._secondaryText;

    EditableButtonController c = new EditableButtonController();
    c.changeSecondName = this._changeText;
    widget._callback(c);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: widget._color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text( '${widget._primaryText} ', style: TextStyle(color: widget._textColor), ),
            Text( '$_secondName', style: TextStyle(
                color: widget._textColor,
                fontWeight: FontWeight.bold ),),
          ],
        ),
        onPressed: () {
          widget._onPressed();
        });
  }

  void _changeText(String text) {
    setState(() {
      _secondName = text;
    });
  }
}

class EditableButtonController {
  Function changeSecondName;
}
