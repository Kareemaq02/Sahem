import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Screens/Home/MainMenuAdmin.dart';
import 'package:account/Screens/Home/MainMenuWorker.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
// ignore_for_file: file_names


class SuccessPage extends StatelessWidget {
  final String text;
  const SuccessPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Widget page =
        userIsAdmin() ? const MainMenuAdmin() : const MainMenuWorker();
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
              child: StyledButton(
                text: "استمرار",
                fontSize: screenWidth * 0.05,
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => WillPopScope(
                      onWillPop: () async => false,
                      child: page,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
