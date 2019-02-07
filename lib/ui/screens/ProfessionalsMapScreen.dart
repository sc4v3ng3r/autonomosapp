import 'package:autonomosapp/firebase/FirebaseUserViewsHelper.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/model/UserView.dart';
import 'package:autonomosapp/ui/screens/ProfessionalPerfilScreen.dart';
import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:badges/badges.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalsMapScreen extends StatefulWidget {
  final CameraPosition _initialCameraPosition;
  final List<User> _dataList;
  final String _screenTitle;

  ProfessionalsMapScreen(
      {@required double initialLatitude, @required initialLongitude,
        @required List<User> professionalList, @required screenTitle}):
      _dataList = professionalList,
      _screenTitle = screenTitle,
      _initialCameraPosition = CameraPosition(
        target: LatLng(initialLatitude, initialLongitude),
      );

  @override
  _ProfessionalsMapScreenState createState() => _ProfessionalsMapScreenState();

}

class _ProfessionalsMapScreenState extends State<ProfessionalsMapScreen> {

  GoogleMapController _controller;
  MapType _currentMapType = MapType.normal;
  CameraPosition _currentCameraPosition;
  double _currentZoom = 16.0;
  Map<String, User> _dataMap = Map();

  @override
  void initState() {
    super.initState();
    _currentCameraPosition = widget._initialCameraPosition;
  }

  @override
  Widget build(BuildContext context) {
    print("ProfessionalsMapScreenBuild");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._screenTitle),
        actions: <Widget>[
          // TEST feature

          IconButton(
            tooltip: Constants.TOOLTIP_MAP_TYPE,
            icon: Icon(Icons.map, color: Colors.white,),
            onPressed: _changeMapType,
          ),

          Tooltip(
            message: Constants.TOOLTIP_PRO_LIST,
            child: BadgeIconButton(
              itemCount: widget._dataList.length,
              icon: Icon( Icons.list, color: Colors.white, ),
              onPressed: (){},
            ),
          ),
        ],
      ),

      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: _currentMapType,
            onMapCreated: _onMapCreated,
            initialCameraPosition: _currentCameraPosition,
            myLocationEnabled: true,
          ),
        ],

      ),
    );
  }

  void _onMapCreated(GoogleMapController controller){
    print("OnMapCreated");
    print("List size: ${widget._dataList.length}");
    _dataMap.clear();
    _controller = controller;

    _controller.animateCamera( 
        CameraUpdate.newLatLngZoom(
            _controller.cameraPosition.target,
            _currentZoom),
        );

    var iterator = widget._dataList.iterator;

    while( iterator.moveNext() ){
      User proUser = iterator.current;
      print("adding ${proUser.name} "
          "lat: ${proUser.professionalData.latitude} "
          "long: ${proUser.professionalData.longitude}");

      var markerOption = MarkerOptions(
        position: LatLng(proUser.professionalData.latitude, proUser.professionalData.longitude),
      );


      _controller.addMarker( markerOption )
          .then( (marker){
              _dataMap.putIfAbsent( marker.id, ()=> proUser);
          } );
    }

    _controller.onMarkerTapped.add( (marker) {
      _showBottomSheet(marker);
    } );

    _controller.addListener( _mapChange );
    //_extractCurrentMapInfo();
  }

  void _showBottomSheet(Marker marker){
    var markProUser = _dataMap[marker.id];
    if (markProUser != null)
      showModalBottomSheet(context: context,
          builder: (buildContext){
            return MapBottomSheetWidget(
              proUser: markProUser,
              contactButtonCallback: () async {

                var whatsUrl =
                  "whatsapp://send?phone=55${markProUser.professionalData.telefone}"
                  "&text=${Constants.getDefaultWhatsappMessage(
                    professionalName: markProUser.name)}";

                await canLaunch(whatsUrl) ?
                  launch(whatsUrl):
                    _showNoWhatsappDialog();
              },

              perfilButtonCallback: (){
                Navigator.of(context).push( MaterialPageRoute(
                    builder: (BuildContext context){
                      return ProfessionalPerfilScreen(
                        userProData: markProUser,
                      );
                    } )
                );

                _registerVisualization( markProUser.uid );
                //compute(_registerVisualization,  markProUser.uid);
               },
            );
          });
  }

  void _showNoWhatsappDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Whatsapp não está instalado"),
                ],
              ),
            ),
          );
    });
  }
  /// TEST
  void _changeMapType(){
    (_currentMapType == MapType.normal) ? _currentMapType = MapType.satellite
        : _currentMapType = MapType.normal;
    setState(() {});
  }


  void _registerVisualization(final String proUid){
    var uid = UserRepository.instance.currentUser.uid;
    if (proUid == uid)
      return;

    var time = DateTime.now();
    String date = "${time.day}/${time.month}/${time.year}";

    var visualization = UserView(
        userVisitorId: uid,
        userVisualizedId: proUid,
        date: date
    );

    FirebaseUserViewsHelper.pushUserVisualization( viewData: visualization );
  }


  void _mapChange(){
    print("on map changed");
  }

  void _extractCurrentMapInfo(){
    //_currentCameraPosition = _controller.cameraPosition;
    //_currentZoom = _currentCameraPosition.zoom;
  }

  @override
  void dispose() {
    _controller.removeListener( _mapChange );
    _dataMap.clear();

    super.dispose();
    print("ProfessionalsMapScreen::dispose()");
  }
}


class MapBottomSheetWidget extends StatelessWidget {
  final User _proUser;
  final Function _perfilCallback;
  final Function _contactCallback;

  MapBottomSheetWidget({
    @required User proUser,
    Function perfilButtonCallback,
    Function contactButtonCallback }) :
      _perfilCallback = perfilButtonCallback,
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
                overflow: TextOverflow.ellipsis,
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

            Constants.VERTICAL_SEPARATOR_8,
            buttonsRow,
          ],
        ),
    );

  }

}
