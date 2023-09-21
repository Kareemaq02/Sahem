import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: file_names


class SquareButtonWithStroke extends StatelessWidget {
  final double height;
  final double width;
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const SquareButtonWithStroke(
      {super.key,
      required this.height,
      required this.width,
      required this.icon,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double iconSize = (0.5 * width + 0.5 * height) / 2;
    double fontSize = (0.1 * width + 0.1 * height) / 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: onPressed,
          child: Ink(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 0.04 * width,
                    color: AppColor.main,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: iconSize,
                        color: AppColor.textTitle,
                      ),
                      Text(
                        text,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: AppColor.textTitle,
                          fontSize: fontSize,
                          fontFamily: 'DroidArabicKufi',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
