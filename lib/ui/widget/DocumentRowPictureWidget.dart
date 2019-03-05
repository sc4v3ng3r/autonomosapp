import 'dart:io';

import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/PictureButtonWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rxdart/rxdart.dart';

class DocumentRowPictureWidget extends StatefulWidget {
  final _frenteRgCallback;
  final _fundoRgCallback;
  final _pessoaRgCallback;
  final DocumentsAuthenticationWidgetBloc _bloc = DocumentsAuthenticationWidgetBloc();

  DocumentRowPictureWidget({
    frenteRgCallback(File imageFile),
    versoRgCallback(File imageFile),
    pessoaRgCallback(File imageFile)
  }) : _frenteRgCallback = frenteRgCallback, _fundoRgCallback = versoRgCallback,
        _pessoaRgCallback = pessoaRgCallback;

  @override
  _DocumentRowPictureWidgetState createState() => _DocumentRowPictureWidgetState();
}

class _DocumentRowPictureWidgetState extends State<DocumentRowPictureWidget> {

  File _frenteRgImage;
  File _versoRgImage;
  File _pessoalImage;

  @override
  Widget build(BuildContext context) {

    final picturesRow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        Expanded(
          child: StreamBuilder<File>(
            initialData: _frenteRgImage,
            stream: widget._bloc._frenteRgSubject,
            builder: (context, snapshot){
              return PictureButtonWidget(
                size: 100,
                imageFile: snapshot.data,
                title: Text("Frente RG"),
                onTapCallback: () async {
                  File pictureFile = await ImagePicker.pickImage(
                    source: ImageSource.camera,
                  );

                  if (pictureFile != null){
                    pictureFile = await _cropImage(pictureFile,
                        aspectRatioY: 0.8, aspectRatioX: 1.0);

                    if (pictureFile != null){
                      _frenteRgImage = pictureFile;
                      widget._bloc.insertFrenteRgFoto( _frenteRgImage );

                      widget._frenteRgCallback(_frenteRgImage);
                    }
                  }
                },
              );
            },
          ),
        ),

        Constants.HORIZONTAL_SEPARATOR_8,

        Expanded(
          child: StreamBuilder<File>(
            initialData: _versoRgImage,
            stream: widget._bloc._versoRgSubject,
            builder: (context, snapshot){
              return PictureButtonWidget(
                size: 100,
                imageFile: snapshot.data,
                title: Text("Verso RG"),
                onTapCallback: () async {
                  File pictureFile = await ImagePicker.pickImage(
                    source: ImageSource.camera,
                  );

                  if (pictureFile != null){
                    pictureFile = await _cropImage(pictureFile,
                        aspectRatioX: 1.0, aspectRatioY: 0.8);

                    if (pictureFile != null){
                      _versoRgImage = pictureFile;
                      widget._bloc.insertVersoRgFoto( _versoRgImage );
                      widget._fundoRgCallback(_versoRgImage);
                    }
                  }
                },
              );
            },
          ),
        ),

        Constants.HORIZONTAL_SEPARATOR_8,

        Expanded(
          child: StreamBuilder<File>(
            initialData: _pessoalImage,
            stream: widget._bloc._pessoaRgSubject,
            builder: (context, snapshot){
              return PictureButtonWidget(
                size: 100,
                imageFile: snapshot.data,
                title: Text("Foto sua segurando o RG", textAlign: TextAlign.center,),
                onTapCallback: () async {
                  File pictureFile = await ImagePicker.pickImage(
                    source: ImageSource.camera,
                  );

                  if (pictureFile != null){
                    pictureFile = await _cropImage(pictureFile, aspectRatioX: 1.0, aspectRatioY: 1.0);

                    if (pictureFile != null){
                      _pessoalImage = pictureFile;
                      widget._bloc.insertPessoaRgFoto( _pessoalImage );
                      widget._pessoaRgCallback( _pessoalImage );
                    }
                  }
                }
              );
            },
          ),
        ),
      ],
    );

    return picturesRow;
  }

  Future<File> _cropImage(File imageFile, {double aspectRatioX= 1.0,
    double aspectRatioY=1.0}) {

    return ImageCropper.cropImage(
        sourcePath: imageFile.path,
        ratioY: aspectRatioY,
        ratioX: aspectRatioX,
        circleShape: false,
        toolbarColor: Theme.of(context).primaryColor,
        toolbarTitle: "Cortar"
    );
  }

  @override
  void dispose() {
    widget._bloc.dispose();
    super.dispose();
  }
}

class DocumentsAuthenticationWidgetBloc {

  final PublishSubject<File> _frenteRgSubject = PublishSubject();
  Observable<File> get frenteRgFoto => _frenteRgSubject.stream;

  final PublishSubject<File> _versoRgSubject = PublishSubject();
  Observable<File> get versoRgFoto => _frenteRgSubject.stream;

  final PublishSubject<File> _pessoaRgSubject = PublishSubject();
  Observable<File> get pessoaRgFoto => _frenteRgSubject.stream;

  DocumentsAuthenticationWidgetBloc(){}

  void insertFrenteRgFoto(final File imageFile) => _frenteRgSubject.sink.add(imageFile);

  void insertVersoRgFoto(final File imageFile) => _versoRgSubject.sink.add(imageFile);

  void insertPessoaRgFoto(final File imageFile) => _pessoaRgSubject.sink.add(imageFile);

  void dispose(){
    _frenteRgSubject?.close();
    _versoRgSubject?.close();
    _pessoaRgSubject?.close();
  }
}