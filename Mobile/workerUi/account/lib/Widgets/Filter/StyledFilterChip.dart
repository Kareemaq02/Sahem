import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';

class StyledFilterChip extends StatelessWidget {
  final bool selected;
  final String text;
  final VoidCallback onPressed;

  const StyledFilterChip(
      {super.key,
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
              fontWeight: FontWeight.bold,
              fontFamily: 'DroidArabicKufi',
            )),
        selected: selected,
        onSelected: (bool selected) => {onPressed()});
  }
}
