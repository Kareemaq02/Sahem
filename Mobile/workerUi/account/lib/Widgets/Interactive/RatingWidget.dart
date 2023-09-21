import 'package:flutter/material.dart';
// ignore_for_file: library_private_types_in_public_api

// ignore_for_file: file_names


class RatingWidget extends StatefulWidget {
  final double rating;
  final double iconSize;
  final Function(double) onChanged;

  const RatingWidget(
      {super.key,
      required this.rating,
      required this.onChanged,
      required this.iconSize});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 0;
  double dragStartRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  void _updateRating(double starValue) {
    setState(() {
      _currentRating = starValue;
    });
    widget.onChanged(_currentRating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        double starValue = index + 1;

        IconData iconData;
        if (starValue <= _currentRating) {
          iconData = Icons.star;
        } else if (starValue - 0.5 <= _currentRating) {
          iconData = Icons.star_half;
        } else {
          iconData = Icons.star_border;
        }

        return GestureDetector(
          onHorizontalDragDown: (details) {
            double tapPosition = details.localPosition.dx / widget.iconSize;
            bool tappedLeft = tapPosition < 0.5;

            if (tappedLeft) {
              starValue -= 0.5;
            }
            dragStartRating = starValue;
            _updateRating(starValue);
          },
          onHorizontalDragUpdate: (details) {
            double dragPosition =
                details.localPosition.dx / widget.iconSize * 1.2;
            int numberOfHalves = (dragPosition / 0.5).floor();
            double newRating = dragStartRating;
            if (numberOfHalves != 0) {
              newRating = dragStartRating + (numberOfHalves / 2);
            }
            _updateRating(newRating.clamp(0.0, 5.0));
          },
          child: Icon(
            iconData,
            size: widget.iconSize,
            color: Colors.yellow,
          ),
        );
      }),
    );
  }
}
