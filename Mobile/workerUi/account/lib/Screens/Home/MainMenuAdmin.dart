import 'package:account/Screens/TaskEvaluation/TaskEvaluation.dart';
import 'package:account/Widgets/Bars/NavBarAdmin.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Utils/NaviTranstion.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Screens/Profile/profile.dart';
import 'package:account/Screens/Analytics/Quarter.dart';
import 'package:account/Widgets/Charts/RatingChart.dart';
import 'package:account/Screens/Analytics/Analytics.dart';
import 'package:account/Screens/CreateTask/CreateTask.dart';
import 'package:account/Screens/Analytics/TeamAnalytics.dart';
import 'package:account/Widgets/Displays/InfoDisplayBox.dart';
import 'package:account/Widgets/Buttons/squareButtonWithStroke.dart';

class MainMenuAdmin extends StatefulWidget {
  const MainMenuAdmin({super.key});

  @override
  _MainMenuAdminState createState() => _MainMenuAdminState();
}

class _MainMenuAdminState extends State<MainMenuAdmin> {
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

    double buttonHeight = 0.145 * screenHeight;
    double buttonWidth = 0.3 * screenWidth;

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavBarAdmin(0),
      appBar: myAppBar(context, "الصفحة الرئيسية", false, screenWidth * 0.45),
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
                            onPressed: () =>
                                {naviTransition(context, const Profile())}),
                        SquareButtonWithStroke(
                            height: buttonHeight,
                            width: buttonWidth,
                            icon: Icons.timelapse_rounded,
                            text: "أداء الربع السنوي",
                            onPressed: () =>
                                {naviTransition(context, const Quarter())}),
                        SquareButtonWithStroke(
                            height: buttonHeight,
                            width: buttonWidth,
                            icon: Icons.bar_chart_rounded,
                            text: "الإحصائيات",
                            onPressed: () =>
                                {naviTransition(context, const Analytics())}),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SquareButtonWithStroke(
                          height: buttonHeight,
                          width: buttonWidth,
                          icon: Icons.groups_outlined,
                          text: "الشعب",
                          onPressed: () =>
                              {naviTransition(context, const TeamAnalytics())},
                        ),
                        SquareButtonWithStroke(
                          height: buttonHeight,
                          width: buttonWidth,
                          icon: Icons.task_alt_rounded,
                          text: "تقييم المهام",
                          onPressed: () =>
                              {naviTransition(context, const TaskEvaluation())},
                        ),
                        SquareButtonWithStroke(
                          height: buttonHeight,
                          width: buttonWidth,
                          icon: Icons.spatial_tracking_sharp,
                          text: "اضافة مهام",
                          onPressed: () =>
                              {naviTransition(context, const CreateTask())},
                        ),
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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
