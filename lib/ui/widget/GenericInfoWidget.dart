import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';

class GenericInfoWidget extends StatelessWidget {

  final String _title;
  final Color _titleColor;
  final String _subtitle;
  final Color _subtitleColor;
  final IconData _icon;
  final double _iconSize;
  final Color _iconColor;
  final bool _actionButton;
  final Color _actionButtonColor;
  final String _actionTitle;
  final Color _actionTitleColor;
  final Function _callback;
  final IconData _actionButtonIcon;
  final Color _actionButtonIconColor;

  GenericInfoWidget( {@required String title, Color titleColor,
    @required String subtitle, Color subtitleColor, @required IconData icon,
    double iconSize = 120, Color iconColor, bool actionButton = false,
    String actionTitle="", Color actionTitleColor, Color actionButtonBackground,
    IconData actionIcon = Icons.refresh, Color actionIconColor, Function actionCallback } ) :
        _title = title,
        _titleColor = titleColor,
        _subtitle = subtitle,
        _subtitleColor = subtitleColor,
        _icon = icon,
        _iconColor = iconColor,
        _iconSize = iconSize,
        _actionButton = actionButton,
        _actionTitle = actionTitle,
        _actionTitleColor = actionTitleColor,
        _actionButtonColor = actionButtonBackground,
        _actionButtonIcon = actionIcon,
        _actionButtonIconColor = actionIconColor,
        _callback = actionCallback;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List();

    //Error Icon
    widgets.add(
      IconButton(
        onPressed: null,
        iconSize: _iconSize,
        icon: Icon(_icon, color: _iconColor ?? Theme.of(context).primaryColor ),
      ),
    );

    // Title
    widgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child:Text(_title,
              maxLines: 2,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: _titleColor ?? Theme.of(context).accentColor ,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0
              ),
            ),
          ),

        ],
      ),
    );

    //subtitle
    widgets.add(
      Container(
        width: 220,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(_subtitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                    fontSize: 14,
                    color: _subtitleColor ?? Theme.of(context).accentColor
                ),
              ),
            )
          ],
        ),
      ),
    );

    if (_actionButton){
      widgets.add(Constants.VERTICAL_SEPARATOR_8);
      widgets.add(
          RaisedButton(
            color: _actionButtonColor ?? Theme.of(context).primaryColor,
            onPressed: _callback,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Icon(_actionButtonIcon ,
                  color: _actionButtonIconColor ?? Theme.of(context).accentColor,
                ),

                Constants.HORIZONTAL_SEPARATOR_8,
                Text( _actionTitle,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: _actionTitleColor ?? Theme.of(context).accentColor
                  ),
                ),
              ],
            ),
          )
      );
    }

    return Column( children: widgets );
  }
}
