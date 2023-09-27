import 'dart:math';
import 'package:account/API/login_request.dart';
import 'package:account/Widgets/Bars/NavBarAdmin.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/Charts/PerformanceChart.dart';
import 'package:account/Widgets/Displays/InfoDisplayBox.dart';
import 'package:account/Widgets/Buttons/StyledFilterChip.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/API/ComplaintsAPI/Get_Complaints_Types.dart';
// ignore_for_file: file_names

class Quarter extends StatefulWidget {
  const Quarter({super.key});

  @override
  _QuarterState createState() => _QuarterState();
}

class _QuarterState extends State<Quarter> {
  final ScrollController _scrollController = ScrollController();

  // Chart Data
  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime endDate = DateTime(DateTime.now().year, 3, 31);
  List<ChartData> complaintData = [];
  List<ChartData> taskData = [];

  // Displays Data
  int complaintCount = 0;
  String avgResolve = "يومين";
  String successRate = "66.7%";

  // Render Vars
  int region = 0;
  int chart = 0;
  List<int> selectedTypes = [];

  // API Vars
  late Future<List<Map<String, dynamic>>> _futureTypesObjs;

  @override
  void initState() {
    super.initState();
    returnChartData();
    _futureTypesObjs = fetchTypesData();
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
    int timeToSolveHours = random.nextInt(74) + 24;
    var timeToSolveDays = timeToSolveHours / 24;
    switch (timeToSolveDays.floor()) {
      case 0:
        avgResolve = "أقل من يوم";
        break;
      case 1:
        avgResolve = "يوم";
        break;
      case 2:
        avgResolve = "يومين";
        break;
      default:
        avgResolve = "${timeToSolveDays.toStringAsFixed(1)} أيام";
        break;
    }
    double tempAvg = tempTasks / complaintCount * 100;
    successRate = "${tempAvg.toStringAsFixed(1)}%";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fullMarginY = 0.01 * screenHeight;
    double halfMarginY = 0.01 * screenHeight;

    double fullMarginX = 0.04 * screenWidth;
    double halfMarginX = 0.02 * screenWidth;

    double boxHeight = 0.15 * screenHeight;
    double boxWidth = 0.31 * screenWidth;

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: userIsAdmin() ? NavBarAdmin(0) : BottomNavBar1(0),
      appBar: myAppBar(context, "أداء الربع السنوي", false, screenWidth * 0.45),
      body: Padding(
        padding: EdgeInsets.only(top: halfMarginY, bottom: halfMarginY),
        child: Column(
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
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                height: 0.07 * screenHeight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: returnRegionsMockApi(
                                      screenWidth, fullMarginX),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IgnorePointer(
                            child: Container(
                              height: 0.07 * screenHeight,
                              width: 0.25 * screenWidth,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.white,
                                    Color.fromARGB(0, 255, 255, 255)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IgnorePointer(
                            child: Container(
                              height: 0.07 * screenHeight,
                              width: 0.25 * screenWidth,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    Colors.white,
                                    Color.fromARGB(0, 255, 255, 255)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                        child: PerformanceChart(
                          complaintData: complaintData,
                          taskData: taskData,
                          startDate: startDate,
                          endDate: endDate,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.17 * screenHeight,
              width: 0.95 * screenWidth,
              margin: EdgeInsets.only(top: halfMarginY),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: fullMarginY / 4,
                        bottom: halfMarginY,
                        right: fullMarginX,
                        left: fullMarginX),
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Text("أنواع البلاغات",
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: AppColor.textTitle,
                            fontSize: 14,
                            fontFamily: 'DroidArabicKufi',
                          )),
                    ),
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _futureTypesObjs,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        var typesObjs = snapshot.data!;
                        int halfLength = (typesObjs.length / 2).ceil();
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: typesObjs
                                    .sublist(0, halfLength)
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return renderCheckBox(
                                    entry,
                                    typesObjs,
                                    fullMarginX,
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                height: fullMarginY,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: typesObjs
                                    .sublist(halfLength)
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return renderCheckBox(
                                    entry,
                                    typesObjs,
                                    fullMarginX,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
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
                        title: "عدد البلاغات",
                        content: complaintCount.toString()),
                    InfoDisplayBox(
                        height: boxHeight,
                        width: boxWidth,
                        title: "مدة المهام",
                        content: avgResolve),
                    InfoDisplayBox(
                        height: boxHeight,
                        width: boxWidth,
                        title: "نسبة النجاح",
                        content: successRate),
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
              returnChartData();
            } else {
              selectedTypes.remove(map["intId"]);
              returnChartData();
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
