import 'dart:math';
import 'package:account/API/ComplaintsAPI/Get_Complaints_Types.dart';
import 'package:account/Utils/Team.dart';
import 'package:account/Widgets/Charts/TeamChart.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Widgets/Interactive/TeamSelectionBox.dart';
import 'package:account/Widgets/Popup/DateRangePopup.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/Charts/PerformanceChart.dart';
import 'package:account/Widgets/Displays/InfoDisplayBox.dart';
import 'package:account/Widgets/Buttons/StyledFilterChip.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TeamAnalytics extends StatefulWidget {
  const TeamAnalytics({super.key});

  @override
  _TeamAnalyticsState createState() => _TeamAnalyticsState();
}

class _TeamAnalyticsState extends State<TeamAnalytics> {
  final ScrollController _scrollController = ScrollController();
  Team selectedTeam = Team(0, "0");
  DateTime selectedDate = DateTime.now().subtract(const Duration(days: 7));
  int timeframe = 1;

  // Chart Data
  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime endDate = DateTime(DateTime.now().year, 3, 31);
  List<ChartData> complaintData = [];
  List<ChartData> taskData = [];

  // Displays Data
  int complaintCount = 0;
  String teamRating = "4.7";
  String successRate = "66.7%";

  // Render Vars
  int region = 0;
  int chart = 0;
  List<int> selectedTypes = [];

  // API Vars
  void setTeam(Team team) {
    selectedTeam = team;
  }

  @override
  void initState() {
    super.initState();
    returnChartData();
  }

  Future<List<Map<String, dynamic>>> fetchTypesData() async {
    var typesRequest = ComplaintTypeRequest();
    var typesData = await typesRequest.getAllCategory();
    List<Map<String, dynamic>> typesObjs = [];
    for (var type in typesData) {
      var typeObj = {
        "intId": type.intTypeId,
        "strName": type.strNameAr,
      };
      typesObjs.add(typeObj);
    }
    return typesObjs;
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

  void returnChartData() {
    // Vars Reset
    complaintData.clear();
    taskData.clear();
    complaintCount = 0;
    int tempTasks = 0;
    // Mock API
    final Random random = Random();
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      final int randomValue = random.nextInt(67) + 71;
      final int randomValue2 = random.nextInt(67) + 24;
      complaintData.add(ChartData(currentDate, randomValue));
      taskData.add(ChartData(currentDate, randomValue2));
      currentDate = currentDate.add(const Duration(days: 7));
      complaintCount += randomValue;
      tempTasks += randomValue2;
    }
    teamRating = (2.0 + Random().nextDouble() * (4.9 - 2.0)).toStringAsFixed(1);
    double tempAvg = tempTasks / complaintCount * 100;
    successRate = "${tempAvg.toStringAsFixed(1)}%";
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
                selectedDate = DateTime.now().subtract(const Duration(days: 7));
              })),
      StyledFilterChip(
          selected: timeframe == 2,
          text: "شهر",
          onPressed: () => setState(() {
                timeframe = 2;
                selectedDate =
                    DateTime.now().subtract(const Duration(days: 30));
              })),
      StyledFilterChip(
          selected: timeframe == 3,
          text: "3 اشهر",
          onPressed: () => setState(() {
                timeframe = 3;
                selectedDate =
                    DateTime.now().subtract(const Duration(days: 91));
              })),
      StyledFilterChip(
          selected: timeframe == 4,
          text: "سنه",
          onPressed: () => setState(() {
                timeframe = 4;
                selectedDate =
                    DateTime.now().subtract(const Duration(days: 365));
              })),
      StyledFilterChip(
        selected: timeframe == 5,
        text: "أخر",
        onPressed: () => setState(
          () {
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
                      child: GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) {
                          double velocity = details.velocity.pixelsPerSecond.dx;
                          if (velocity > 0) {
                            setState(() {
                              startDate =
                                  startDate.subtract(const Duration(days: 91));
                              endDate =
                                  endDate.subtract(const Duration(days: 91));
                              returnChartData();
                            });
                          } else {
                            setState(() {
                              startDate =
                                  startDate.add(const Duration(days: 91));
                              endDate = endDate.add(const Duration(days: 91));
                              returnChartData();
                            });
                          }
                        },
                        child: const TeamChart(),
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
            TeamSelectionBox(
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
                        content: complaintCount.toString()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding renderCheckBox(
    MapEntry<int, Map<String, dynamic>> entry,
    List<dynamic> typesObjs,
    double fullMarginX,
  ) {
    final int index = entry.key;
    final Map<String, dynamic> map = entry.value;
    int halfLength = (typesObjs.length / 2).ceil();
    var isLastElement = index == typesObjs.length - 1;
    var isMiddleElement = index == halfLength - 1;
    var padding = isLastElement || isMiddleElement
        ? EdgeInsets.only(right: fullMarginX)
        : EdgeInsets.only(left: fullMarginX / 2, right: fullMarginX / 2);
    return Padding(
      padding: padding,
      child: StyledCheckBox(
        text: map["strName"],
        isChecked: selectedTypes.contains(map["intId"]),
        onChanged: () {
          setState(() {
            if (!selectedTypes.contains(map["intId"])) {
              selectedTypes.add(map["intId"]);
            } else {
              selectedTypes.remove(map["intId"]);
            }
          });
        },
        fontSize: 14,
      ),
    );
  }

  List<Widget> returnRegionsMockApi(double screenWidth, double fullMarginX) {
    List<String> regionNames = [
      "راس العين",
      "جبل النزهة",
      "شفا بدران",
      "المقابلين",
      "الياسمين",
      "ماركا",
      "جبل الحسين",
      "ابو نصير"
    ];
    List<Widget> regionChips = [];
    for (int i = 0; i < regionNames.length; i++) {
      regionChips.add(
        StyledFilterChip(
          selected: region == i,
          text: regionNames[i],
          onPressed: () {
            setState(() {
              returnChartData();
              region = i;
              scrollRegions(i, screenWidth);
            });
          },
        ),
      );
    }
    regionChips.insert(0, SizedBox(width: fullMarginX * 3));
    regionChips.add(SizedBox(width: fullMarginX * 3));

    return regionChips;
  }

  void scrollRegions(int index, double screenWidth) {
    double offset = 0.12 * screenWidth * index;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.ease,
    );
  }
}
