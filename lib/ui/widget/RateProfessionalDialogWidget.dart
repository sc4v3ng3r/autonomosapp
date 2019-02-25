import 'package:autonomosapp/ui/widget/RatingBar.dart';
import 'package:flutter/material.dart';

/// Classe widget que permite o usuário atribuir uma avaliação
/// de 0 à 5 em estrelinhas.
///
class RateProfessionalDialogWidget extends StatefulWidget {

  final Function _confirmCallback;

  RateProfessionalDialogWidget( {@required Function onConfirm(double rate) } )
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
      title: Text("Avaliar"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: RatingBar(
              color: Theme.of(context).primaryColor,
              //borderColor: Theme.of(context).accentColor,
              starCount: 5,
              size: 45,
              editable: true,
              rating: _rating,
              allowHalfRating: true,
              onRatingChanged: (rating){
                _rating = rating;
                print("rating changed");
                setState(() {});
              },
            ),
          ),
        ],
      ),

      actions: <Widget>[
        RaisedButton(
          onPressed: (){
            widget._confirmCallback( _rating );
          },
          color: Colors.green,
          child: Text("Confirmar", style: TextStyle( color: Colors.white ), ),
        ),

        RaisedButton(
          onPressed: (){
            Navigator.pop(context);
          },

          color: Theme.of(context).errorColor,
          child: Text("Cancelar", style: TextStyle( color: Colors.white ), ),
        ),
      ],
    );
  }
}