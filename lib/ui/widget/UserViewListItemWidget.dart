import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/model/UserView.dart';
import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/NetworkRoundedPictureWidget.dart';

class UserViewListItemWidget extends StatelessWidget {
  final User _user;
  final UserView _view;

  UserViewListItemWidget({ @required User user, @required UserView view }) :
    _user = user,
    _view = view;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: NetworkRoundedPictureWidget(
        height: 50,
        width: 50,
        networkImageUrl: _user?.picturePath,
      ),

      title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_user?.name ?? Constants.USER_DELETED,
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
              rating: _user?.rating ?? 5.0,
              cor: (_user == null) ? Colors.grey[400] : Colors.amber,
            ),
          ],
      ),

      trailing: Text(_view?.date ?? "----",
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.black45,
          ),
      ),

      onTap: null,
    );
  }

}
