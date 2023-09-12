import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String text;
  final double fontSize;
  final bool? isLoading;
  final VoidCallback onPressed;

  const StyledButton({
    super.key,
    this.height,
    this.width,
    required this.text,
    required this.fontSize,
    this.isLoading,
    required this.onPressed,
  });

  Widget buildContent() {
    if (isLoading == null) {
      return Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
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
                color: Colors.white,
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
          color: Colors.white,
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.main,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: buildContent(),
      ),
    );
  }
}
