import 'package:flutter/material.dart';


//TODO ainda eh stateless tem que ser statefull para mudar o estado!!
// ou utilizar a tecnica ninja mostrada pelos caras da google
typedef void RatingChangeCallBack(double rating);

class RatingBar extends StatelessWidget {
  final int starCount;
  final double rating;
  final bool editable;
  final RatingChangeCallBack onRatingChanged;
  final Color color;
  final Color borderColor;
  final double size;
  final bool allowHalfRating;

  RatingBar(
      {this.starCount = 5,
        this.rating = 0.0,
        this.editable = false,
        this.onRatingChanged,
        this.color,
        this.borderColor,
        this.size,
        this.allowHalfRating = true});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: borderColor ?? Theme.of(context).primaryColor,
        size: size ?? 25.0,
      );
    } else if (index >= rating - (allowHalfRating ? 0.5 : 1.0) &&
        index <= rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? 25.0,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? 25.0,
      );
    }

    if (!editable)
      return icon;

    return new GestureDetector(
      onTap: () {
        if (this.onRatingChanged != null) onRatingChanged(index + 1.0);
      },
      onHorizontalDragUpdate: (dragDetails) {
        RenderBox box = context.findRenderObject();
        var _pos = box.globalToLocal(dragDetails.globalPosition);
        var i = _pos.dx / size;
        var newRating = allowHalfRating ? i : i.round().toDouble();
        if (newRating > starCount) {
          newRating = starCount.toDouble();
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        if (this.onRatingChanged != null) onRatingChanged(newRating);
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: new Wrap(
          alignment: WrapAlignment.start,
          children: new List.generate(
              starCount, (index) => buildStar(context, index ))),
    );
  }
}