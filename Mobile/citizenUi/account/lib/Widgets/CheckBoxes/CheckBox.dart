import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';

class CheckBoxNew extends StatelessWidget {
  final String text;
  final bool isChecked;
  final VoidCallback onChanged;

  const CheckBoxNew({
    super.key,
    required this.text,
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
                fontSize: 12,
                fontFamily: 'DroidArabicKufi'),
          ),
          Checkbox(
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
        ],
      ),
    );
  }
}
