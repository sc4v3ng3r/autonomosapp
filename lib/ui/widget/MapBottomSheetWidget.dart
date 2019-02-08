import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/model/Location.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

/// BottomSheet utilizada na ProfessionalMapScreen
class MapBottomSheetWidget extends StatelessWidget {
  final User _proUser;
  final Function _perfilCallback;
  final Function _contactCallback;
  final Location _myLocation;

  MapBottomSheetWidget({
    @required User proUser,
    @required Location currentLocation,
    Function perfilButtonCallback,
    Function contactButtonCallback }) :
        _perfilCallback = perfilButtonCallback,
        _myLocation = currentLocation,
        _contactCallback = contactButtonCallback,
        _proUser = proUser;

  @override
  Widget build(BuildContext context) {

    var buttonsRow = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            onPressed: (){
              if (_perfilCallback != null)
                _perfilCallback();
            },
            child: Text("Perfil", style: TextStyle(color: Colors.white),),
            color: Colors.blue,
          ),
        ),

        Constants.HORIZONTAL_SEPARATOR_8,

        Expanded(
          child: RaisedButton(
            onPressed: (){
              if (_contactCallback != null)
                _contactCallback();
            },
            child: Text("Contactar Whatsapp",
                style: TextStyle(color: Colors.white) ),
            color: Colors.green,
          ),
        ),
      ],
    );

    print("bottomSheet builded");
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 120.0,
            height: 120.0,
            child: (_proUser.picturePath != null) ?
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: _proUser.picturePath,
                placeholder: CircularProgressIndicator(),
              ),
            ) :
            CircleAvatar(
              backgroundImage: AssetImage(
                  Constants.ASSETS_LOGO_USER_PROFILE_FILE_NAME
              ),
            ),
          ),

          Center(
            child: Text("${_proUser.name}",
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          //Constants.VERTICAL_SEPARATOR_8,
          Center(
            child: RatingBar(
              starCount: 5,
              cor: Colors.amberAccent,
              rating: _proUser.rating,
            ),
          ),

          FutureBuilder<double>(
            future: Geolocator().distanceBetween(
                _myLocation.latitude,
                _myLocation.longitude,
                _proUser.professionalData.latitude,
                _proUser.professionalData.longitude),
            builder: (buildContext, snapshot){
              if (snapshot.hasData){
                var distance = snapshot.data;
                String text;
                if (distance > 1000){
                  distance/=1000;
                  text = Constants.LABEL_KM;
                }
                else text = Constants.LABEM_M;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text( distance.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),

                    Constants.HORIZONTAL_SEPARATOR_8,

                    Text(
                      text,
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
          ),
          Constants.VERTICAL_SEPARATOR_8,
          buttonsRow,
        ],
      ),
    );

  }

}