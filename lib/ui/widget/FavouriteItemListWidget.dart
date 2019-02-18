import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/NetworkRoundedPictureWidget.dart';
import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';

class FavouriteItemListWidget extends StatelessWidget {

  final User favoriteUser;
  final _onTapCallback;
  final _onDeleteCallback;

  FavouriteItemListWidget({@required this.favoriteUser,
    void onTap(final User user), void onDelete(final User user)} ) :
      _onDeleteCallback = onDelete,
      _onTapCallback = onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: NetworkRoundedPictureWidget(
          height: 50,
          width: 50,
          networkImageUrl: favoriteUser?.picturePath,
        ),

        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(favoriteUser?.name ?? Constants.USER_DELETED,
              overflow: TextOverflow.clip,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),

            RatingBar(
              starCount: 5,
              onRatingChanged: null,
              rating: favoriteUser?.rating ?? 5.0,
              cor: (favoriteUser == null) ? Colors.grey[400] : Theme.of(context).primaryColor,
            ),
          ],
        ),

        trailing: IconButton(
          icon: Icon(Icons.delete_forever,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () { if (_onDeleteCallback != null) _onDeleteCallback(favoriteUser); },
        ),

        onTap: (){ if (_onTapCallback!=null) _onTapCallback(favoriteUser); },
      ),
    );
  }
}
