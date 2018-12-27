import 'package:flutter/material.dart';

class EditableButton extends StatefulWidget {

  final Function _onPressed;
  final Function _callback;

  EditableButton({@required Function onPressed,
    @required controllerCallback(EditableButtonController controller) }) :
      _onPressed = onPressed,
      _callback = controllerCallback;

  @override
  _EditableButtonState createState() => _EditableButtonState();
}

class _EditableButtonState extends State<EditableButton> {

  String secondName = "";

  @override
  void initState() {
    super.initState();
    EditableButtonController c = new EditableButtonController();
    c.changeSecondName = this._changeText;
    widget._callback(c);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Colors.red[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text( 'Cidades ', style: TextStyle(color: Colors.white), ),
            Text( '$secondName', style: TextStyle(color: Colors.black54),),
          ],
        ),
        onPressed: () {
          widget._onPressed();
        });
  }

  void _changeText(String text) {
    setState(() {
      secondName = text;
    });
  }
}

class EditableButtonController {
  Function changeSecondName;
}
