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
      stream: widget._bloc.currentImage,
      builder: (context, snapshot){
        if (snapshot.hasData){
          print("HAS IMAGE PROVIDER DATA");
          return createWidget( snapshot.data );
        }


        else{
          print("HAS NOT IMAGE PROVIDER DATA");
          return createWidget( AssetImage("assets/usuario.png") );
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
  ReplaySubject<ImageProvider<dynamic>> get currentImage => _publishSubject.stream;

  CircularPictureWidgetBloc({@required ImageProvider<dynamic> initialImageProvider}){
    addToSink(initialImageProvider);
  }

  void addToSink( ImageProvider<dynamic> provider) => _publishSubject.sink.add(provider);

  dispose(){
    _publishSubject?.close();
  }

}