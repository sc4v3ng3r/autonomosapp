import 'package:flutter/material.dart';


class FormLayoutWidget extends StatefulWidget {

  final GlobalKey<FormState> _key;
  final List<Widget> _widgetList;
  final bool _autoValidate;

  FormLayoutWidget({
    @required GlobalKey formKey,
    @required List<Widget> widgets,
    bool autoValidate = false}) : _key = formKey,
        _widgetList =widgets,
        _autoValidate = autoValidate;

  @override
  _FormLayoutWidgetState createState() => _FormLayoutWidgetState();
}

class _FormLayoutWidgetState extends State<FormLayoutWidget> {

  @override
  Widget build(BuildContext context) {

    return Form(
      key: widget._key,
      //autovalidate: ,
      child: Column(
        children: widget._widgetList,
      ),
    );
  }
}
