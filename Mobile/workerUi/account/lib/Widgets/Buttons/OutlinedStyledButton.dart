import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';

class OutlinedStyledButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String text;
  final double fontSize;
  final bool? isLoading;
  final VoidCallback onPressed;

  const OutlinedStyledButton({
    Key? key,
    this.height,
    this.width,
    required this.text,
    required this.fontSize,
    this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  Widget buildContent() {
    if (isLoading == null) {
      return Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: AppColor.main, // Change text color to the desired color
          fontFamily: 'DroidArabicKufi',
        ),
      );
    }
    if (isLoading! && height != null) {
      return SizedBox(
        height: height,
        width: height! * 2,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height! * 0.2, horizontal: height! * 0.65),
          child: SizedBox(
            height: height,
            width: height,
            child: const Center(
              child: CircularProgressIndicator(
                color:
                    AppColor.main, // Change the CircularProgressIndicator color
              ),
            ),
          ),
        ),
      );
    } else {
      return Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: AppColor.main, // Change text color to the desired color
          fontFamily: 'DroidArabicKufi',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColor.main), // Border color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: buildContent(),
      ),
    );
  }
}
