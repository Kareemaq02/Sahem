import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/Charts/RatingChart.dart';
import 'package:account/Widgets/CheckBoxes/checkBox.dart';
import 'package:account/Widgets/Charts/StyledFilterChip.dart';
import 'package:account/Widgets/Displays/InfoDisplayBox.dart';

class Quarter extends StatefulWidget {
  const Quarter({super.key});

  @override
  _QuarterState createState() => _QuarterState();
}

class _QuarterState extends State<Quarter> {
  @override
  void initState() {
    super.initState();
  }

  int region = 1;
  int chart = 0;
  final ScrollController _scrollController = ScrollController();
  List<int> selectedTypes = [];

  void selectChart(int index) {
    setState(() {
      chart == index ? chart = 0 : chart = index;
    });
  }

// Change int to Widget when fully working
  void scrollRegions(int index, List<int> timechips, double screenWidth) {
    double offset = (index - (timechips.length / 2)) * (0.2 * screenWidth);
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.ease,
    );
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

    double boxHeight = 0.15 * screenHeight;
    double boxWidth = 0.31 * screenWidth;

    final regionChipsIds = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    final regionChips = [
      SizedBox(
        width: fullMarginX * 3,
      ),
      StyledFilterChip(
          selected: region == 1,
          text: "راس العين",
          onPressed: () => setState(() {
                region = 1;
                scrollRegions(0, regionChipsIds, screenWidth);
              })),
      StyledFilterChip(
          selected: region == 2,
          text: "جبل النزهة",
          onPressed: () => setState(() {
                region = 2;
                scrollRegions(1, regionChipsIds, screenWidth);
              })),
      StyledFilterChip(
          selected: region == 3,
          text: "شفا بدران",
          onPressed: () => setState(() {
                region = 3;
                scrollRegions(2, regionChipsIds, screenWidth);
              })),
      StyledFilterChip(
          selected: region == 4,
          text: "المقابلين",
          onPressed: () => setState(() {
                region = 4;
                scrollRegions(3, regionChipsIds, screenWidth);
              })),
      StyledFilterChip(
          selected: region == 5,
          text: "الياسمين",
          onPressed: () => setState(() {
                region = 5;
                scrollRegions(4, regionChipsIds, screenWidth);
              })),
      StyledFilterChip(
          selected: region == 6,
          text: "ماركا",
          onPressed: () => setState(() {
                region = 6;
                scrollRegions(5, regionChipsIds, screenWidth);
              })),
      StyledFilterChip(
          selected: region == 7,
          text: "جبل الحسين",
          onPressed: () => setState(() {
                region = 7;
                scrollRegions(6, regionChipsIds, screenWidth);
              })),
      StyledFilterChip(
          selected: region == 8,
          text: "ابو نصير",
          onPressed: () => setState(() {
                region = 8;
                scrollRegions(7, regionChipsIds, screenWidth);
              })),
      SizedBox(
        width: fullMarginX * 3,
      ),
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
          child: CheckBoxNew(
            text: entry["strName"],
            isChecked: entry["isChecked"],
            onChanged: checkboxFunction,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      // floatingActionButton: const CustomActionButton(),
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
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              height: 0.07 * screenHeight,
                              width: regionChips.length * 0.2 * screenWidth,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: regionChips,
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
                    const Expanded(child: RatingChart()),
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
                    InfoDisplayBox(
                        height: boxHeight,
                        width: boxWidth,
                        title: "عدد البلاغات",
                        content: "247"),
                    InfoDisplayBox(
                        height: boxHeight,
                        width: boxWidth,
                        title: "مدة المهام",
                        content: "يومين"),
                    InfoDisplayBox(
                        height: boxHeight,
                        width: boxWidth,
                        title: "نسبة النجاح",
                        content: "66.7%"),
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
