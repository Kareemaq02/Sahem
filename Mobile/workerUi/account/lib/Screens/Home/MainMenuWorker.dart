import 'package:flutter/material.dart';
import 'package:account/Utils/Team.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Utils/NaviTranstion.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Screens/Profile/profile.dart';
import 'package:account/Widgets/Charts/TeamChart.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Screens/Analytics/Quarter.dart';
import 'package:account/Screens/Analytics/Analytics.dart';
import 'package:account/API/TeamsAPI/GetTeamAnalytics.dart';
import 'package:account/Screens/View%20tasks/task_list.dart';
import 'package:account/Screens/CurrentTask/currentTask.dart';
import 'package:account/Widgets/Displays/InfoDisplayBox.dart';
import 'package:account/Widgets/Buttons/squareButtonWithStroke.dart';

class MainMenuWorker extends StatefulWidget {
  const MainMenuWorker({super.key});

  @override
  _MainMenuWorkerState createState() => _MainMenuWorkerState();
}

class _MainMenuWorkerState extends State<MainMenuWorker> {
  @override
  void initState() {
    super.initState();
    getCharts();
  }

  TeamData complete = TeamData(0, "مكتمل");
  TeamData incomplete = TeamData(0, "غير مكتمل");
  TeamData scheduled = TeamData(0, "مجدول");
  TeamData waitingEvaluation = TeamData(0, "قيد التقييم");

  int complaintCount = 0;
  String rating = "0.0";

  void getCharts() async {
    Future<TeamAnalyticsModel> teamModel =
        TeamsAnalyticsRequest().getTeamsAnalyticsByLoggedInMemeber();
    var team = await teamModel;

    complaintCount = team.intTasksScheduledCount;
    rating = team.lstMembersAvgRating
        .where((element) => element.intId == getUserData().intId)
        .first
        .decRating
        .toStringAsFixed(1);

    setState(() {
      complete = TeamData(team.intTasksCompletedCount, "مكتمل");
      incomplete = TeamData(team.intTasksIncompleteCount, "غير مكتمل");
      scheduled = TeamData(team.intTasksScheduledCount, "مجدول");
      waitingEvaluation =
          TeamData(team.intTasksWaitingEvaluationCount, "قيد التقييم");
    });
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
      bottomNavigationBar: BottomNavBar1(0),
      appBar: myAppBar(context, "الصفحة الرئيسية", false, screenWidth * 0.55),
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
                        SizedBox(
                          height: buttonHeight,
                          width: buttonWidth,
                        ),
                        SquareButtonWithStroke(
                            height: buttonHeight,
                            width: buttonWidth,
                            icon: Icons.spatial_tracking_sharp,
                            text: "المهمة المفعلة",
                            onPressed: () =>
                                {naviTransition(context, const CurrentTask())}),
                        SquareButtonWithStroke(
                            height: buttonHeight,
                            width: buttonWidth,
                            icon: Icons.card_membership_rounded,
                            text: "المهام",
                            onPressed: () =>
                                {naviTransition(context, const XDTasksList())}),
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
                child: Text("ملخص أداء الفريق",
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
                    title: "عدد المهام المجدوله ",
                    content: complaintCount.toString()),
                InfoDisplayBox(
                  height: 0.12 * screenHeight,
                  width: 0.45 * screenWidth,
                  title: "التقييم الخاص",
                  content: rating,
                  icon: Icons.star_rate_rounded,
                  iconColor: AppColor.line,
                ),
              ],
            ),
            // Chart
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: halfMarginY, bottom: halfMarginY),
                width: 0.95 * screenWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: TeamChart(
                  data: <TeamData>[
                    complete,
                    scheduled,
                    incomplete,
                    waitingEvaluation
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
