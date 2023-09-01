import 'package:account/Repository/color.dart';
import 'package:account/Screens/Analytics/Analytics.dart';
import 'package:account/Screens/Home/public_feed.dart';
import 'package:account/Screens/Profile/profile.dart';
import 'package:account/Screens/View%20complaints/complaints_list.dart';
import 'package:account/Widgets/Charts/RatingChart.dart';
import 'package:account/Widgets/Displays/InfoDisplayBox.dart';
import 'package:account/Widgets/appBar.dart';
import 'package:account/Widgets/bottomNavBar.dart';
import 'package:account/Widgets/Buttons/squareButtonWithStroke.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fullMarginY = 0.02 * screenHeight;
    double halfMarginY = 0.01 * screenHeight;

    double fullMarginX = 0.04 * screenWidth;
    // double halfMarginX = 0.02 * screenWidth;

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
                height: 0.3 * screenHeight,
                width: 0.98 * screenWidth,
                color: AppColor.background,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SquareButtonWithStroke(
                            height: buttonHeight,
                            width: buttonWidth,
                            icon: Icons.settings_rounded,
                            text: "الإعدادات",
                            onPressed: () => {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Profile()))
                                }),
                        SquareButtonWithStroke(
                            height: buttonHeight,
                            width: buttonWidth,
                            icon: Icons.timelapse_rounded,
                            text: "أداء الربع السنوي",
                            onPressed: () => {}),
                        SquareButtonWithStroke(
                          height: buttonHeight,
                          width: buttonWidth,
                          icon: Icons.bar_chart_rounded,
                          text: "الإحصائيات",
                          onPressed: () => {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Analytics()))
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: buttonHeight,
                          width: buttonWidth,
                        ),
                        SquareButtonWithStroke(
                            height: buttonHeight,
                            width: buttonWidth,
                            icon: Icons.forum_rounded,
                            text: "المنتدى العام",
                            onPressed: () => {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const XDPublicFeed1()))
                                }),
                        SquareButtonWithStroke(
                            height: buttonHeight,
                            width: buttonWidth,
                            icon: Icons.card_membership_rounded,
                            text: "بلاغاتي",
                            onPressed: () => {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const XDComplaintsList()))
                                }),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // Sub-title
            Padding(
              padding: EdgeInsets.only(
                  top: fullMarginY,
                  bottom: fullMarginY,
                  right: fullMarginX,
                  left: fullMarginX),
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text("ملخص الأداء",
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: AppColor.textTitle,
                      fontSize: 16,
                      fontFamily: 'DroidArabicKufi',
                    )),
              ),
            ),
            // Display boxes
            SizedBox(
              width: 0.95 * screenWidth,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoDisplayBox(
                      height: 0.12 * screenHeight,
                      width: 0.45 * screenWidth,
                      title: "عدد البلاغات الناجحه",
                      content: "2,452"),
                  InfoDisplayBox(
                      height: 0.12 * screenHeight,
                      width: 0.45 * screenWidth,
                      title: "متوسط مدة حل البلاغ",
                      content: "3 أيام"),
                ],
              ),
            ),
            // Chart
            Expanded(
              child: Container(
                  margin:
                      EdgeInsets.only(top: halfMarginY, bottom: halfMarginY),
                  width: 0.95 * screenWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: const RatingChart()),
            )
          ],
        ),
      ),
    );
  }
}
