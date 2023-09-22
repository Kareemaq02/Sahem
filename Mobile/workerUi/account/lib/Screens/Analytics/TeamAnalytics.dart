import 'package:account/API/TeamsAPI/GetTeamAnalytics.dart';
import 'package:account/Utils/Team.dart';
import 'package:account/Widgets/Charts/TeamChart.dart';
import 'package:account/Widgets/Interactive/TeamAnalyticsBox.dart';
import 'package:account/Widgets/Popup/DateRangePopup.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/Displays/InfoDisplayBox.dart';
import 'package:account/Widgets/Buttons/StyledFilterChip.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TeamAnalytics extends StatefulWidget {
  const TeamAnalytics({super.key});

  @override
  _TeamAnalyticsState createState() => _TeamAnalyticsState();
}

class _TeamAnalyticsState extends State<TeamAnalytics> {
  // Render Vars
  int timeframe = 1;

  // Request Vars
  DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime endDate = DateTime.now();
  TeamAnalyticsModel selectedTeam = TeamAnalyticsModel(
    intTeamId: 0,
    intTasksCount: 0,
    intTasksCompletedCount: 0,
    intTasksScheduledCount: 0,
    intTasksIncompleteCount: 0,
    intTasksWaitingEvaluationCount: 0,
    decTeamRatingAvg: 0.0,
    lstMembersAvgRating: <TeamMembersRating>[],
  );

  // API Vars
  TeamData complete = TeamData(0, "مكتمل");
  TeamData incomplete = TeamData(0, "غير مكتمل");
  TeamData scheduled = TeamData(0, "مجدول");
  TeamData waitingEvaluation = TeamData(0, "قيد التقييم");

  int tasksCount = 0;
  String teamRating = "0";
  String successRate = "0.0%";

  ///

  void setTeam(Team team) async {
    var teamMembersRequest =
        TeamsAnalyticsRequest().getTeamsAnalytics(team.intId);
    selectedTeam = await teamMembersRequest;
    setState(() {
      complete = TeamData(selectedTeam.intTasksCompletedCount, "مكتمل");
      incomplete = TeamData(selectedTeam.intTasksIncompleteCount, "غير مكتمل");
      scheduled = TeamData(selectedTeam.intTasksScheduledCount, "مجدول");
      waitingEvaluation =
          TeamData(selectedTeam.intTasksWaitingEvaluationCount, "قيد التقييم");
      tasksCount = selectedTeam.intTasksCount;
      teamRating = selectedTeam.decTeamRatingAvg.toString();
      successRate =
          "${(selectedTeam.intTasksCompletedCount / selectedTeam.intTasksCount).toDouble().toStringAsFixed(1)}%";
    });
  }

  // API Functions

  @override
  void initState() {
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    PickerDateRange dateRange = args.value;
    if (dateRange.endDate != null) {
      setState(() {
        startDate = dateRange.startDate!;
        endDate = dateRange.endDate!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fullMarginY = 0.01 * screenHeight;
    double halfMarginY = 0.01 * screenHeight;

    // double fullMarginX = 0.04 * screenWidth;
    double halfMarginX = 0.02 * screenWidth;

    double boxHeight = 0.15 * screenHeight;
    double boxWidth = 0.31 * screenWidth;

    double teamWidth = screenWidth * 0.95;
    double teamHeight = screenHeight * 0.24;

    final timechips = [
      StyledFilterChip(
          selected: timeframe == 1,
          text: "اسبوع",
          onPressed: () => setState(() {
                timeframe = 1;
                startDate = DateTime.now().subtract(const Duration(days: 7));
                endDate = DateTime.now();
              })),
      StyledFilterChip(
          selected: timeframe == 2,
          text: "شهر",
          onPressed: () => setState(() {
                timeframe = 2;
                startDate = DateTime.now().subtract(const Duration(days: 30));
                endDate = DateTime.now();
              })),
      StyledFilterChip(
          selected: timeframe == 3,
          text: "3 اشهر",
          onPressed: () => setState(() {
                timeframe = 3;
                startDate = DateTime.now().subtract(const Duration(days: 91));
                endDate = DateTime.now();
              })),
      StyledFilterChip(
          selected: timeframe == 4,
          text: "سنه",
          onPressed: () => setState(() {
                timeframe = 4;
                startDate = DateTime.now().subtract(const Duration(days: 365));
                endDate = DateTime.now();
              })),
      StyledFilterChip(
        selected: timeframe == 5,
        text: "أخر",
        onPressed: () => setState(
          () {
            timeframe = 5;
            showDateRangeDialog(
              "أختر الفترة",
              context,
              screenHeight * 0.5,
              _onSelectionChanged,
              PickerDateRange(startDate, endDate),
            );
          },
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar1(0),
      appBar: myAppBar(context, "الصفحه الرئيسية", false, screenWidth * 0.35),
      body: Padding(
        padding: EdgeInsets.only(top: halfMarginY, bottom: halfMarginY),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Container(
                height: 0.45 * screenHeight,
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
                      children: timechips,
                    ),
                    Expanded(
                      child: TeamChart(
                        data: <TeamData>[
                          complete,
                          scheduled,
                          incomplete,
                          waitingEvaluation
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            // Team Box
            TeamAnalyticsBox(
              height: teamHeight,
              width: teamWidth,
              boxHeight: boxHeight,
              boxWidth: boxWidth,
              onChecked: setTeam,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: halfMarginY,
                    left: halfMarginX,
                    right: halfMarginX,
                    bottom: fullMarginY),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InfoDisplayBox(
                        height: boxHeight,
                        width: boxWidth,
                        title: "نسبة النجاح",
                        content: successRate),
                    InfoDisplayBox(
                        height: boxHeight,
                        width: boxWidth,
                        title: "التقييم",
                        content: teamRating),
                    InfoDisplayBox(
                      height: boxHeight,
                      width: boxWidth,
                      title: "عدد البلاغات",
                      content: tasksCount.toString(),
                    ),
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
