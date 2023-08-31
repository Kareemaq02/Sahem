import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Charts/RatingChart.dart';
import 'package:account/Widgets/Charts/TimeframeChip.dart';
import 'package:account/Widgets/Displays/InfoDisplayBox.dart';
import 'package:account/Widgets/appBar.dart';
import 'package:account/Widgets/bottomNavBar.dart';
import 'package:account/Widgets/Buttons/squareButtonWithStroke.dart';
import 'package:flutter/material.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  void initState() {
    super.initState();
  }

  int timeframe = 1;

  @override
  Widget build(BuildContext context) {
    //MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fullMarginY = 0.02 * screenHeight;
    double halfMarginY = 0.01 * screenHeight;

    double fullMarginX = 0.04 * screenWidth;
    double halfMarginX = 0.02 * screenWidth;

    double buttonHeight = 0.145 * screenHeight;
    double buttonWidth = 0.3 * screenWidth;

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton: const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar1(0),
      appBar: myAppBar(context, "الصفحه الرئيسية", false, 170),
      body: Padding(
        padding: EdgeInsets.only(top: halfMarginY, bottom: halfMarginY),
        child: Column(
          children: [
            // Buttons
            Center(
              child: Container(
                height: 0.43 * screenHeight,
                width: 0.95 * screenWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TimeframeChip(
                            timeframe: 1,
                            selected: timeframe == 1,
                            text: "اسبوع",
                            onPressed: () => setState(() => timeframe = 1)),
                        TimeframeChip(
                            timeframe: 2,
                            selected: timeframe == 2,
                            text: "شهر",
                            onPressed: () => setState(() => timeframe = 2)),
                      ],
                    ),
                    const RatingChart(),
                  ],
                ),
              ),
            ),
            // Sub-title
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(
                    top: fullMarginY,
                    bottom: fullMarginY,
                    right: fullMarginX,
                    left: fullMarginX),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text("أنواع البلاغات",
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AppColor.textTitle,
                        fontSize: 16,
                        fontFamily: 'DroidArabicKufi',
                      )),
                ),
              ),
            ),
            // Display boxes
          ],
        ),
      ),
    );
  }
}
