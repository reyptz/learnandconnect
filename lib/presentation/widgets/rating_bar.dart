import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final int rating;
  final int maxRating;
  final Color color;
  final double size;

  const RatingBar({
    Key? key,
    required this.rating,
    this.maxRating = 5,
    this.color = Colors.amber,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        maxRating,
            (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: color,
          size: size,
        ),
      ),
    );
  }
}
