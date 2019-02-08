import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/NetworkRoundedPictureWidget.dart';
import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';

class UserListItemWidget extends StatelessWidget {
  final User _user;
  final Function _onTapCallback;
  final Future<double> _distance;

  UserListItemWidget({
    @required User user, Function onTap(),
    Future<double> distance,}) :
    _user = user,
    _distance = distance,
    _onTapCallback = onTap;

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
          Text(_user?.name ?? "",
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

      trailing: _buildTrailing(),
      onTap: _onTapCallback,
    );
  }

  Widget _buildTrailing(){
    return FutureBuilder<double>(
      future: _distance,
      builder: (context, snapshot){
        if (snapshot.hasData){
          var distance = snapshot.data;
          String text = "";
          if (distance > 1000){
            distance/=1000;
            text = Constants.LABEL_KM;
          }
          else text = Constants.LABEM_M;

            return Column(
              children: <Widget>[
                Text( distance.toStringAsFixed(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),

                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black45,
                  ),
                ),
              ],
            );
        }

        return Container(
          width: .0,
          height: .0,
        );
      },
    );
  }
}
