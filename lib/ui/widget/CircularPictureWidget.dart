import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CircularEditablePictureWidget extends StatefulWidget {

  final Function _onClickCallback;
  final CircularPictureWidgetBloc _bloc;

  CircularEditablePictureWidget({ Function onClickCallback,
    @required CircularPictureWidgetBloc bloc}) :
        _bloc = bloc,
        _onClickCallback = onClickCallback;

  @override
  _CircularEditablePictureWidgetState createState() => _CircularEditablePictureWidgetState();
}

class _CircularEditablePictureWidgetState extends State<CircularEditablePictureWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget._bloc.currentImageProvider,
      builder: (context, snapshot){
        if (snapshot.hasData){
          return createWidget( snapshot.data );
        }
        else {
          return createWidget( AssetImage(
              Constants.ASSETS_LOGO_USER_PROFILE_FILE_NAME )
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget createWidget(ImageProvider<dynamic> imageProvider){
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Material(
        elevation: 8.0,
        color: Colors.transparent,
        child: Ink.image(
          width: 160.0,
          height: 160.0,
          image: imageProvider,
          fit: BoxFit.cover,
          child: InkWell(
            onTap: (){
              if (widget._onClickCallback!=null)
                widget._onClickCallback();
            },
          ),
        ),
      ),
    );
  }
}

class CircularPictureWidgetBloc {
  ReplaySubject<ImageProvider<dynamic>> _publishSubject = ReplaySubject(maxSize: 1);
  ReplaySubject<ImageProvider<dynamic>> get currentImageProvider => _publishSubject.stream;

  CircularPictureWidgetBloc({@required ImageProvider<dynamic> initialImageProvider}){
    addToSink(initialImageProvider);
  }

  void addToSink( ImageProvider<dynamic> provider) => _publishSubject.sink.add(provider);

  dispose(){
    _publishSubject?.close();
  }

}