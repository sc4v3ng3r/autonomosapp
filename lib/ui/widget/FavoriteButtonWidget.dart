import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';


enum FavoriteAction { FAVORITE, UNFAVOURITE }

class FavoriteButtonWidget extends StatefulWidget {
  final Function _onStateChange;
  final Color _color;
  final bool _isFavorite;

  FavoriteButtonWidget({
    @required Function(FavoriteAction action) callback,
    Key key,
    Color color,
    bool favorite = false
  }) :
        _isFavorite = favorite,
        _color = color,
        _onStateChange = callback, super( key: key);

  @override
  FavoriteButtonWidgetState createState() => FavoriteButtonWidgetState();
}

class FavoriteButtonWidgetState extends State<FavoriteButtonWidget> {
  FavoriteAction _state;

  @override
  void initState() {
    super.initState();
    _state = (widget._isFavorite) ? FavoriteAction.FAVORITE
        : FavoriteAction.UNFAVOURITE;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _toolTipMessage(),
      child: IconButton(
          icon: (_state == FavoriteAction.FAVORITE) ? Icon(
            Icons.favorite, color: widget._color,)
              : Icon(Icons.favorite_border, color: widget._color,),
          onPressed: () {
            setState(() {
              _state =
              (_state == FavoriteAction.FAVORITE) ? FavoriteAction.UNFAVOURITE
                  : FavoriteAction.FAVORITE;
            });

            if (widget._onStateChange != null)
              widget._onStateChange(_state);
          }
      ),
    );
  }

  String _toolTipMessage(){
    return _state == FavoriteAction.FAVORITE ? Constants.TOOLTIP_REMOVE_FROM_FAVOURITES
      : Constants.TOOLTIP_ADD_TO_FAVOURITES;
  }

  void changeAction(final FavoriteAction action) {
    setState(() {
      _state = action;
    });
  }
}