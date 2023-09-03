import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';

class TimeframeChip extends StatelessWidget {
  final int timeframe;
  final bool selected;
  final String text;
  final VoidCallback onPressed;

  const TimeframeChip(
      {super.key,
      required this.timeframe,
      required this.selected,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    //MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double halfMarginX = 0.02 * screenWidth;

    return FilterChip(
        showCheckmark: false,
        padding: EdgeInsets.only(left: halfMarginX / 4, right: halfMarginX / 4),
        backgroundColor: Colors.white,
        pressElevation: 2,
        selectedColor: Colors.white,
        shadowColor: Colors.white,
        side: selected ? const BorderSide(color: AppColor.main) : null,
        label: Text(text,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: selected ? AppColor.main : Colors.grey,
              fontSize: 12,
              fontFamily: 'DroidArabicKufi',
            )),
        selected: selected,
        onSelected: (bool selected) => {null});
  }
}