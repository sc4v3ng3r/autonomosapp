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
    return IconButton(
        icon: (_state == FavoriteAction.FAVORITE) ? Icon(
          Icons.star, color: widget._color,)
            : Icon(Icons.star_border, color: widget._color,),
        onPressed: () {
          setState(() {
            _state =
            (_state == FavoriteAction.FAVORITE) ? FavoriteAction.UNFAVOURITE
                : FavoriteAction.FAVORITE;
          });

          if (widget._onStateChange != null)
            widget._onStateChange(_state);
        }
    );
  }

  void changeAction(final FavoriteAction action) {
    setState(() {
      _state = action;
    });
  }
}