import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';

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
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColor.main,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
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
    );
  }
}
