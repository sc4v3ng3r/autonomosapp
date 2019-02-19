import 'package:autonomosapp/utility/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkRoundedPictureWidget extends StatelessWidget {
  final String _networkImage;
  final double _width;
  final double _height;

  NetworkRoundedPictureWidget({String networkImageUrl, double width = 50, double height = 50}) :
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
          placeholder: (BuildContext context, String str){
            return CircularProgressIndicator();
          },
        ),
      ) :
      CircleAvatar(
        backgroundImage: AssetImage(
            Constants.ASSETS_LOGO_USER_PROFILE_FILE_NAME
        ),),
    );
  }
}