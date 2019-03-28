import 'package:autonomosapp/firebase/FirebaseUserViewsHelper.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/model/UserView.dart';
import 'package:autonomosapp/ui/screens/ProfessionalListScreen.dart';
import 'package:autonomosapp/ui/screens/ProfessionalPerfilScreen.dart';
import 'package:autonomosapp/ui/widget/MapBottomSheetWidget.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/DateTimeUtility.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            icon: Icon(Icons.map, color: Theme.of(context).accentColor ),
            onPressed: _changeMapType,
          ),

          Tooltip(
            message: Constants.TOOLTIP_PRO_LIST,
            child: BadgeIconButton(
              itemCount: widget._dataList.length,
              icon: Icon( Icons.list ),
              onPressed: _showProfessionalListScreen,
            ),
          ),
        ],

        brightness: Brightness.dark,
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
              currentLocation: UserRepository.instance.currentLocation,
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
                Navigator.of(context).pop();

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
  // TEM QUE VIRAR UM MÈTODO GENERICO
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

  /// TODO vai para o BLoC
  void _registerVisualization(final String proUid){
    Future<void>.delayed(Duration(seconds: 1), (){

      var uid = UserRepository.instance.currentUser.uid;
      if (proUid == uid)
        return;

      String date = DateTimeUtility.getCurrentDateString();

      var visualization = UserView(
          userVisitorId: uid,
          userVisualizedId: proUid,
          date: date
      );

      FirebaseUserViewsHelper.pushUserVisualization( viewData: visualization );
    } ).then((_) => print("Visualização Registrada") );
  }

  void _mapChange(){
    print("on map changed");
  }

  void _showProfessionalListScreen(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return ProfessionalListScreen(
            location: UserRepository.instance.currentLocation,
            professionalList: widget._dataList,
          );
        } ),
    );
  }
  @override
  void dispose() {
    _controller.removeListener( _mapChange );
    _dataMap.clear();

    super.dispose();
    print("ProfessionalsMapScreen::dispose()");
  }

}// end of class

