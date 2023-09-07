import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double? fontSize;

  const TitleText({
    super.key,
    required this.text,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        color: AppColor.textTitle,
        fontSize: fontSize ?? 16,
        fontFamily: 'DroidArabicKufi',
      ),
    );
  }
}
