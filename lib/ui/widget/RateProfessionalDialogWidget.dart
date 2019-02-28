import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/NetworkRoundedPictureWidget.dart';

/// Classe widget que permite o usuário atribuir uma avaliação
/// de 0 à 5 em estrelinhas.
///
class RateProfessionalDialogWidget extends StatefulWidget {

  final Function _confirmCallback;
  final User professional;

  RateProfessionalDialogWidget( {@required Function onConfirm(double rate),
    @required this.professional} )
    : _confirmCallback = onConfirm;

  @override
  State<StatefulWidget> createState() => _RateProfessionalDialogWidgetState();

}

class _RateProfessionalDialogWidgetState extends State<RateProfessionalDialogWidget> {

  double _rating;

  @override
  void initState() {
    super.initState();
    _rating = 2.5;

  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 0.0),
      title: Text("Avaliar Profissional"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 24.0),
                child: NetworkRoundedPictureWidget(
                  networkImageUrl: widget.professional.picturePath,
                  height: 150,
                  width: 150,
                )
              ),
            ],
          ),
          Constants.VERTICAL_SEPARATOR_8,
          
          Flexible(
            child: Text("${widget.professional.name}",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 18,
              ),
            ),
          ),

          Constants.VERTICAL_SEPARATOR_8,

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: RatingBar(
                  color: Theme.of(context).primaryColor,
                  starCount: 5,
                  size: 45,
                  editable: true,
                  rating: _rating,
                  allowHalfRating: true,
                  onRatingChanged: (rating){
                    _rating = rating;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),

          Constants.VERTICAL_SEPARATOR_8,

          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (widget._confirmCallback != null)
                      widget._confirmCallback(_rating);
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(.0),
                    padding: EdgeInsets.all(16.0),
                    child: Text("Confirmar",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

    );
  }
}