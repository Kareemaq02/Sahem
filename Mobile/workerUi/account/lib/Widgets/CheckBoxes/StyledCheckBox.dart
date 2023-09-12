import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';

class StyledCheckBox extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool isChecked;
  final VoidCallback onChanged;

  const StyledCheckBox({
    super.key,
    required this.text,
    required this.fontSize,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {onChanged()},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: TextStyle(
                color: isChecked ? AppColor.main : Colors.grey,
                fontSize: fontSize,
                fontFamily: 'DroidArabicKufi'),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Checkbox(
              value: isChecked,
              onChanged: (bool? value) => {onChanged()},
              activeColor: AppColor.main,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
                side: const BorderSide(
                  color: AppColor.main,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
