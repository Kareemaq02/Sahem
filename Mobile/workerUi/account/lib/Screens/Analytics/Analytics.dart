import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/Charts/RatingChart.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Widgets/Filter/StyledFilterChip.dart';
import 'package:account/Widgets/Buttons/IconToggleButton.dart';

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
  int chart = 0;
  Widget renderedChart = renderChart(0);
  DateTime selectedDate = DateTime.now().subtract(const Duration(days: 7));
  List<int> selectedTypes = [];

  void selectChart(int index) {
    setState(() {
      chart == index ? chart = 0 : chart = index;
      renderedChart = renderChart(chart);
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
          onPressed: () => setState(() {
                timeframe = 5;
                selectDate(context);
              })),
    ];

    List<Map<String, dynamic>> typesObjs = returnTypesMockApi(selectedTypes);
    List<Widget> rowChildren = [];
    int halfLength = (typesObjs.length / 2).ceil();
    for (var index = 0; index < typesObjs.length; index++) {
      var entry = typesObjs[index];

      var isLastElement = index == typesObjs.length - 1;
      var isMiddleElement = index == halfLength - 1;

      var padding = isLastElement || isMiddleElement
          ? EdgeInsets.only(right: fullMarginX)
          : EdgeInsets.only(left: halfMarginX, right: halfMarginX);

      void checkboxFunction() {
        setState(() {
          if (!selectedTypes.contains(entry["intId"])) {
            selectedTypes.add(entry["intId"]);
            entry["isChecked"] = true;
          } else {
            selectedTypes.remove(entry["intId"]);
            entry["isChecked"] = false;
          }
        });
      }

      rowChildren.add(
        Padding(
          padding: padding,
          child: StyledCheckBox(
            text: entry["strName"],
            fontSize: 12,
            isChecked: entry["isChecked"],
            onChanged: checkboxFunction,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      //floatingActionButton: const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar1(0),
      appBar: myAppBar(context, "الصفحه الرئيسية", false, screenWidth * 0.35),
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
                  SingleChildScrollView(
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
                          children: rowChildren.sublist(0, halfLength),
                        ),
                        SizedBox(
                          height: fullMarginY,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: rowChildren.sublist(halfLength),
                        ),
                      ],
                    ),
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
}

Widget renderChart(int chart) {
  Widget sentChart = const Center(child: Text('Loading...'));
  switch (chart) {
    case 1:
      sentChart = const RatingChart();
      break;
    case 2:
      sentChart = const RatingChart();
      break;
    case 3:
      sentChart = const RatingChart();
      break;
    default:
      sentChart = const RatingChart();
      break;
  }
  return FutureBuilder(
    future: Future.delayed(const Duration(milliseconds: 300)),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: Text('Loading...'));
      } else {
        return sentChart;
      }
    },
  );
}

List<Map<String, dynamic>> returnTypesMockApi(List<int> selectedTypes) {
  return [
    {
      "intId": 1,
      "strName": "حفر الشوارع",
      "isChecked": selectedTypes.contains(1),
    },
    {
      "intId": 2,
      "strName": "تراكم نفايات",
      "isChecked": selectedTypes.contains(2),
    },
    {
      "intId": 3,
      "strName": "مطبات مخالفة",
      "isChecked": selectedTypes.contains(3),
    },
    {
      "intId": 4,
      "strName": "تكسر ارصفة",
      "isChecked": selectedTypes.contains(4),
    },
    {
      "intId": 5,
      "strName": "2 حفر الشوارع",
      "isChecked": selectedTypes.contains(5),
    },
    {
      "intId": 6,
      "strName": "2 تراكم نفايات",
      "isChecked": selectedTypes.contains(6),
    },
    {
      "intId": 7,
      "strName": "2 مطبات مخالفة",
      "isChecked": selectedTypes.contains(7),
    },
    {
      "intId": 8,
      "strName": "2 تكسر ارصفة",
      "isChecked": selectedTypes.contains(8),
    },
  ];
}
