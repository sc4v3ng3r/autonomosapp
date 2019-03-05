import 'dart:io';
import 'package:flutter/material.dart';

class PictureButtonWidget extends StatelessWidget {
  final Function onTapCallback;
  final File imageFile;
  final double size;
  final Widget title;

  PictureButtonWidget({@required this.onTapCallback, this.imageFile,
    this.size = 80, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        (imageFile == null) ? _widgetWithNoImage(context)
            : _widgetWithImage(context),

        Flexible(
          child: Container(
            child: title,
          ),
        ),
      ],
    );
  }

  Widget _widgetWithNoImage(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).accentColor,
        ),
      ),
      width: size,
      height: size,
      child: InkWell(
        child: IconButton(
          icon: Icon(Icons.add,
            color: Theme.of(context).accentColor,
          ),
          iconSize: (size/2),
          onPressed: null,
        ),
        onTap: onTapCallback,
      ),
    );
  }

  Widget _widgetWithImage(BuildContext context){
    return Container(
      width: size,
      height: size,
      child: InkWell(
        onTap: onTapCallback,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            ),
            Image.file( imageFile,fit: BoxFit.cover,
              height: size,
              width: size,
            ),
          ],
        )
      ),

      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

}