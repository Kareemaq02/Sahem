import 'package:account/Repository/color.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColor.main,
            ),
            TitleText(text: "جاري التحميل...")
          ],
        ),
      ),
    );
  }
}
