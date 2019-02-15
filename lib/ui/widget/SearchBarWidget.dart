import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {

  final _textHint;
  final _color;
  final Function _onTypedCallback;
  final TextEditingController _textFieldController = TextEditingController();
  final FocusNode _textFieldFocusNode = new FocusNode();

  SearchBarWidget(  {String hint = "Pesquisar...",
    @required Function onTyped(String text), Color color }) :
      _textHint = hint,
      _color = color,
      _onTypedCallback = onTyped;

  @override
  State createState() {
    return SearchBarWidgetState();
  }
}

class SearchBarWidgetState extends State<SearchBarWidget> {

  TextEditingController _textFieldController;
  FocusNode _textFieldFocusNode;

  @override
  void dispose() {
    _textFieldController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textFieldController = TextEditingController();
    _textFieldController.addListener(_textListener);
    _textFieldFocusNode = new FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  print("SearchBarWidget  build");
    var field = Material(
        color: widget._color ?? Theme.of(context).primaryColor,
        elevation: 8.0,

      child: Padding (
          padding: EdgeInsets.only(left: 8.0,top: 0.0, right: 8.0, bottom: 6.0),
          child: TextFormField(
            maxLines: 1,
            autofocus: false,
            focusNode: _textFieldFocusNode,
            controller: _textFieldController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),

            decoration: InputDecoration(
                hasFloatingPlaceholder: false,
                labelText: widget._textHint,
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor
                  ),
                  borderRadius: BorderRadius.circular(22.0),
                ),

                prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(end: 4.0),
                    child: IconButton(icon: Icon(Icons.search), onPressed: () {
                      if (!_textFieldFocusNode.hasFocus)
                        FocusScope.of(context).requestFocus(_textFieldFocusNode);
                    })
                ),

                //TODO callback para o sufix item
                suffixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(end: 12.0),
                    child: IconButton(icon: Icon(Icons.clear),
                        onPressed: () {
                          _textFieldController.clear();
                        })
                ),

                labelStyle: TextStyle(
                  fontSize: 18.0,
                ),

                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0),
                )
            ),
          ),
        ),
    );

    return  Row(
      children: <Widget>[
        Flexible(
            child: field,
        ),
      ],
    );
  }

  void _textListener(){
    if (widget._onTypedCallback != null){
      widget._onTypedCallback( _textFieldController.text);
    }
  }
}
