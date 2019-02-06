import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/model/UserView.dart';
import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

///
class UserViewItemWidget extends StatelessWidget {
  final User _user;
  final UserView _view;

  UserViewItemWidget({ @required User user, @required UserView view }) :
    _user = user,
    _view = view;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: RoundedPictureWidget(
        height: 60,
        width: 60,
        networkImageUrl: _user.picturePath,
      ),

      title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_user.name,
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
              rating: _user.rating,
              cor: Colors.amber,
            ),

          ],
      ),

      trailing: Text("11/10/18",
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.black45,
          ),
      ),

      onTap: null,
    );

    /*return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0 ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          RoundedPictureWidget(
            height: 80,
            width: 80,
            networkImageUrl: _user.picturePath,
          ),

          Constants.HORIZONTAL_SEPARATOR_16,

          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_user.name,
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
                  rating: _user.rating,
                  cor: Colors.amber,
                ),

              ],
            ),
          ),

         Text("11/10/18",
           textAlign: TextAlign.end,
           style: TextStyle(
             fontSize: 10.0,
             color: Colors.black45,
           ),
          ),
        ],
      ),
    );*/

  }

}

class RoundedPictureWidget extends StatelessWidget {
  final String _networkImage;
  final double _width;
  final double _height;

  RoundedPictureWidget({String networkImageUrl, double width = 100, double height = 100}) :
      _width = width,
      _height = height,
      _networkImage = networkImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      child: (_networkImage != null) ?
      ClipOval(
        child: CachedNetworkImage(
          imageUrl: _networkImage,
          placeholder: CircularProgressIndicator(),
        ),
      ) :
      CircleAvatar(
        backgroundImage: AssetImage(
            Constants.ASSETS_LOGO_USER_PROFILE_FILE_NAME
        ),),
    );
  }
}
