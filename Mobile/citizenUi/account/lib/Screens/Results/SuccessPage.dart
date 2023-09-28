import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/MainMenu/MainMenu.dart';
import 'package:account/Widgets/HelperWidegts/titleText.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
// ignore_for_file: file_names


class SuccessPage extends StatelessWidget {
  final String text;
  const SuccessPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.25,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth * 0.65,
                  child: Lottie.asset(
                    "assets/animations/success_green.json",
                    repeat: false,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TitleText(
                  text: text,
                  fontSize: screenWidth * 0.05,
                ),
                SizedBox(height: screenHeight * 0.2),
              ],
            ),
            SizedBox(
                height: screenHeight * 0.065,
                width: screenWidth * 0.5,
                child: BottonContainer("إستمرار ", Colors.white, AppColor.main,
                    230, context, false, const MainMenu(), () {}))
          ],
        ),
      ),
    );
  }
}
