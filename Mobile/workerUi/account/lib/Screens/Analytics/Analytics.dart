import 'package:account/API/ComplaintsAPI/Get_Complaints_Types.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Widgets/Popup/DateRangePopup.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/Charts/RatingChart.dart';
import 'package:account/Widgets/Charts/PercentChart.dart';
import 'package:account/Widgets/Charts/AverageTimeChart.dart';
import 'package:account/Widgets/Buttons/IconToggleButton.dart';
import 'package:account/Widgets/Buttons/StyledFilterChip.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Widgets/Charts/ComplaintTaskChart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:account/API/ComplaintsAPI/Get_Complaints_Types.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  void initState() {
    super.initState();
    _futureTypesObjs = fetchTypesData();
  }

  int timeframe = 1;
  int chart = 0;
  Widget renderedChart = renderChart(0);
  DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime endDate = DateTime.now();
  List<int> selectedTypes = [];
  late Future<List<Map<String, dynamic>>> _futureTypesObjs;

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

  void selectChart(int index) {
    setState(() {
      chart == index ? chart = 0 : chart = index;
      renderedChart = renderChart(chart);
    });
  }

  @override
  Widget build(BuildContext context) {
    //MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fullMarginY = 0.01 * screenHeight;
    double halfMarginY = 0.01 * screenHeight;

    double fullMarginX = 0.04 * screenWidth;
    double halfMarginX = 0.02 * screenWidth;

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
          onPressed: () => setState(() {
                timeframe = 5;
                showDateRangeDialog(
                  "أختر الفترة",
                  context,
                  screenHeight * 0.5,
                  _onSelectionChanged,
                  PickerDateRange(startDate, endDate),
                );
              })),
    ];

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar1(0),
      appBar: myAppBar(context, "الإحصائيات ", false, screenWidth * 0.55),
      body: Padding(
        padding: EdgeInsets.only(top: halfMarginY, bottom: halfMarginY),
        child: Column(
          children: [
            // Buttons
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
                    Expanded(child: renderedChart),
                  ],
                ),
              ),
            ),
            // Sub-title
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
            // Display boxes
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
                    IconToggleButton(
                        height: 0.15 * screenHeight,
                        width: 0.31 * screenWidth,
                        text: "تقييم المهام",
                        icon: Icons.emoji_emotions_outlined,
                        isChecked: chart == 1,
                        onPressed: () => {selectChart(1)}),
                    IconToggleButton(
                        height: 0.15 * screenHeight,
                        width: 0.31 * screenWidth,
                        text: "حالة البلاغات",
                        icon: Icons.percent_rounded,
                        isChecked: chart == 2,
                        onPressed: () => {selectChart(2)}),
                    IconToggleButton(
                        height: 0.15 * screenHeight,
                        width: 0.31 * screenWidth,
                        text: "مدة حل البلاغ",
                        icon: Icons.av_timer_rounded,
                        isChecked: chart == 3,
                        onPressed: () => {selectChart(3)}),
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
}

Widget renderChart(int chart) {
  Widget sentChart;
  switch (chart) {
    case 1:
      sentChart = const RatingChart();
      break;
    case 2:
      sentChart = const PercentChart();
      break;
    case 3:
      sentChart = const AverageTimeChart();
      break;
    default:
      sentChart = const ComplaintTaskChart();
      break;
  }
  return FutureBuilder(
    future: Future.delayed(const Duration(milliseconds: 300)),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
            child: SizedBox(
                child: CircularProgressIndicator(
          color: AppColor.main,
        )));
      } else {
        return sentChart;
      }
    },
  );
}
