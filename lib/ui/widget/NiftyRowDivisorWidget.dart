import 'package:flutter/material.dart';

class NiftyRowDivisorWidget extends StatelessWidget {
  final _rowColor;
  final _rowHeight;
  final _leftMargin;
  final _rightMargin;
  final _title;

  NiftyRowDivisorWidget( { Color rowColor = Colors.grey, double height = 1.0,
    EdgeInsetsGeometry textLeftMargin = const EdgeInsets.only(left: 8.0),
    EdgeInsetsGeometry textRightMargin = const EdgeInsets.only(right: 8.0), @required String title } )
    : _rowColor = rowColor,
      _rowHeight = height,
      _leftMargin = textLeftMargin,
      _rightMargin = textRightMargin,
      _title = title;

  @override
  Widget build(BuildContext context) {
    final leftLine = Expanded(
      child:Container(
        color: _rowColor,
        height: _rowHeight,
        margin: _rightMargin,
      ),
    );

    final rightLine = Expanded(
      child: Container(
        color: _rowColor,
        height: _rowHeight,
        margin: _leftMargin,
      ),
    );

    return Row(
      children: <Widget>[
        leftLine,
        Text(_title),
        rightLine,
      ],
    );
  }
}
