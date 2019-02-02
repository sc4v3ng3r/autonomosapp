import 'package:autonomosapp/model/ProfessionalData.dart';
import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfessionalsMapScreen extends StatefulWidget {
  //static final double _defaultZoom = 16.0;
  final CameraPosition _initialCameraPosition;
  final List<ProfessionalData> _dataList;

  ProfessionalsMapScreen(
      {@required double initialLatitude, @required initialLongitude,
        @required List<ProfessionalData> professionalList}):
      _dataList = professionalList,
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
  Map<String, ProfessionalData> _dataMap = Map();

  @override
  void initState() {
    super.initState();
    _currentCameraPosition = widget._initialCameraPosition;
  }

  @override
  Widget build(BuildContext context) {
    print("ProfessionalsMapScreenBuild");
    return Scaffold(
      body: Stack(
        children: <Widget>[

          GoogleMap(
            mapType: _currentMapType,
            onMapCreated: _onMapCreated,
            initialCameraPosition: _currentCameraPosition,
            myLocationEnabled: true,
          ),

          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  child: Icon(Icons.map, color: Colors.white,),
                  backgroundColor: Colors.green,
                  onPressed: (){
                    _currentMapType = (_currentMapType == MapType.satellite) ? MapType.normal : MapType.satellite;
                    //setState(() { });
                  }
               ),
            ),
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
      ProfessionalData proData = iterator.current;
      print("adding ${proData.nome} lat: ${proData.latitude} long: ${proData.longitude}");

      var markerOption = MarkerOptions(
        position: LatLng(proData.latitude, proData.longitude),
        //infoWindowText: InfoWindowText( proData.nome, proData.descricao),
      );


      _controller.addMarker( markerOption )
          .then( (marker){
              _dataMap.putIfAbsent( marker.id, ()=> proData);
          } );
    }

    _controller.onMarkerTapped.add( (marker){
      print("ON mark tap ${marker.id}");
      _showBottomSheet(marker);
    } );

    _controller.addListener( _mapChange );
    _extractCurrentMapInfo();
  }


  void _showBottomSheet(Marker marker){
    var proData = _dataMap[marker.id];
    if (proData != null)
      showModalBottomSheet(context: context,
          builder: (buildContext){
            return MapBottomSheetWidget(
              data: proData,
            );
          });
  }

  void _mapChange(){
   // print("on map changed");
    //_extractCurrentMapInfo();
   // setState(() { });
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
  final ProfessionalData _professionalData;
  final _perfilButtonCallback;
  final _callWhatsappCallback;

  MapBottomSheetWidget({ProfessionalData data,
    Function perfilButtonCallback,
    Function callWhatsappCallback}) :
      _perfilButtonCallback = perfilButtonCallback,
      _callWhatsappCallback = callWhatsappCallback,
      _professionalData = data;

  @override
  Widget build(BuildContext context) {
    print("build bottom sheet");

    var buttonsRow = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            onPressed: (){},
            child: Text("Perfil", style: TextStyle(color: Colors.white),),
            color: Colors.blue,
          ),
        ),

        Constants.HORIZONTAL_SEPARATOR_8,

        Expanded(
          child: RaisedButton(
            onPressed: (){},
            child: Text("Contactar Whatsapp",
                style: TextStyle(color: Colors.white) ),
            color: Colors.green,
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 120.0,
              height: 120.0,
              child: (_professionalData.photoUrl != null) ?
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: _professionalData.photoUrl,
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
              child: Text("${_professionalData.nome}",
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
                rating: 5.0,
              ),
            ),

            Constants.VERTICAL_SEPARATOR_8,
            buttonsRow,
          ],
        ),
    );

  }
}


