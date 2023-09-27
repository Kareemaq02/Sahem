import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: file_names


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
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: AppColor.textTitle,
        fontWeight: FontWeight.bold,
        fontSize: fontSize ?? 16,
        fontFamily: 'DroidArabicKufi',
      ),
    );
  }
}
