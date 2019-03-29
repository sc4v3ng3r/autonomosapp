import 'dart:io';

import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ChoosePictureBottomSheetWidget extends StatelessWidget {

  final Function _callback;

  ChoosePictureBottomSheetWidget({
  @required Function onSelected(File imageFile) }) : _callback = onSelected;

  @override
  Widget build(BuildContext context) {
    File imageFile;

    return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                      iconSize: 70.0,

                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: <Widget>[
                          Flexible(
                            child: Icon( Icons.photo_camera, size: 55, ),
                          ),

                          Flexible(
                            child:  Text("Câmera",
                              style: TextStyle(
                                  fontSize: 16.0
                              ),)
                            ,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        imageFile = await ImagePicker.pickImage(
                            source: ImageSource.camera);

                        if (imageFile != null){
                          File croppedImage = await _cropImage(imageFile);

                          if (_callback != null && croppedImage !=null)
                            _callback(croppedImage);

                          print("Selected ${imageFile?.path}");
                        }

                      }
              ),

              IconButton(
                  iconSize: 70.0,
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Flexible(
                        child: Icon( Icons.photo_library, size: 55,),
                      ),

                      Flexible(child:  Text("Galeria",
                        style: TextStyle(
                            fontSize: 16.0
                        ),
                      )),
                    ],
                  ),
                  onPressed: () async {
                    imageFile = await ImagePicker.pickImage(
                        source: ImageSource.gallery );

                    if (imageFile != null){
                      File croppedImage = await _cropImage(imageFile);
                      if (croppedImage != null){
                        if (_callback!=null && croppedImage!= null)
                          _callback(croppedImage);
                        print("Selected ${imageFile.path}");
                      }
                    }
                  }
              ),
            ],
        ),
    );
  }

  Future<File> _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: imageFile?.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 150,
        maxHeight: 150,
        circleShape: true
    );

    return croppedImage;
  }
}
