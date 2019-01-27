import 'package:flutter/material.dart';


class TextInputWidget extends StatefulWidget {
  static const _DEFAULT_TEXT_STYLE = const TextStyle(
    color: Colors.black,
    fontSize: 20.0,
  );

  final String _hint;
  final int _maxLines;
  final int _maxLength;
  final _autofocus;
  final FocusNode _focusNode;
  final TextEditingController _textEditingController;
  final InputDecoration _decoration;
  final TextStyle _style;
  final TextInputType _textInputType;
  final TextInputAction _inputAction;
  final Function _onFieldSubmitCallback;
  final  _validator;

  TextInputWidget({@required TextEditingController controller,
    validator(String value),
    FocusNode focusNode, String hint, int maxLines = 1, bool autofocus = false,
    TextInputType textInputType = TextInputType.text, int maxLength,
    TextInputAction inputAction = TextInputAction.done,
    Function onFieldSubmitCallback(String value),
    InputDecoration decoration, TextStyle style = _DEFAULT_TEXT_STYLE}):
      _inputAction = inputAction,
      _maxLength = maxLength,
      _validator = validator,
      _textEditingController = controller,
      _onFieldSubmitCallback = onFieldSubmitCallback,
      _focusNode = focusNode,
      _style = style,
      _decoration = decoration,
      _textInputType = textInputType,
      _autofocus = autofocus,
      _maxLines = maxLines,
      _hint = hint;

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        controller: widget._textEditingController,
        focusNode: widget._focusNode,
        autofocus: widget._autofocus,
        validator: widget._validator,
        maxLines: widget._maxLines,
        maxLength: widget._maxLength,
        keyboardType: widget._textInputType,
        textInputAction: widget._inputAction,
        style: widget._style,
        decoration: _getInputDecoration(),
        onFieldSubmitted: (dataTyped){
          if (widget._onFieldSubmitCallback != null)
            widget._onFieldSubmitCallback(dataTyped);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  InputDecoration _getInputDecoration (){
    if (widget._decoration != null)
      return widget._decoration;

    return InputDecoration(
        hasFloatingPlaceholder: true,
        labelText: widget._hint,
        labelStyle: TextStyle(
          fontSize: 16.0,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22.0),
        )
      );
  }
}
