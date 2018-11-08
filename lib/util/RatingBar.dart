import 'package:flutter/material.dart';
typedef void RatingChangeCallBack(double rating);

class StarRating extends StatelessWidget{
  final int starCount;
  final double rating;
  final RatingChangeCallBack onRatingChanged;
  final Color cor;

  StarRating({
    this.starCount = 5, this.rating = .0,
    this.onRatingChanged, this.cor}
      );

  Widget construirEstrelas(BuildContext context,int index){

    Icon icone;
    if(index>=rating){
      icone = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    }//ex:  Se index = 2,5 e rating = 3
    else if(index> rating -1 && index<rating){
      icone = new Icon(
        Icons.star_half,
        color: cor ?? Colors.yellow,
      );
    }else{
      icone = new Icon(
        Icons.star,
        color: cor ?? Colors.yellow,
      );
    }
    return new InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icone,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Row(
        children:
        new List.generate(starCount, (index) => construirEstrelas(context, index))
    );
  }
}