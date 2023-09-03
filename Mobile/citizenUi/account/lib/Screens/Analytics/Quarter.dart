import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Charts/PerformanceChart.dart';
import 'package:account/Widgets/Charts/StyledFilterChip.dart';
import 'package:account/Widgets/CheckBoxes/CheckBox.dart';
import 'package:account/Widgets/Displays/InfoDisplayBox.dart';
import 'package:account/Widgets/appBar.dart';
import 'package:account/Widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:account/API/get_complaints_types.dart';

class Quarter extends StatefulWidget {
  const Quarter({super.key});

  @override
  _QuarterState createState() => _QuarterState();
}

class _QuarterState extends State<Quarter> {
  @override
  void initState() {
    super.initState();
    _futureTypesObjs = fetchTypesData();
  }

  final ScrollController _scrollController = ScrollController();

  // API Vars
  int region = 0;
  int chart = 0;
  int complaintCount = 247;
  String avgResolve = "يومين";
  String successRate = "66.7%";
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fullMarginY = 0.02 * screenHeight;
    double halfMarginY = 0.01 * screenHeight;

    double fullMarginX = 0.04 * screenWidth;
    double halfMarginX = 0.02 * screenWidth;

    double boxHeight = 0.15 * screenHeight;
    double boxWidth = 0.31 * screenWidth;

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
                                width: returnRegionsMockApi(
                                            screenWidth, fullMarginX)
                                        .length *
                                    0.2 *
                                    screenWidth,
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
                    const Expanded(child: PerformanceChart()),
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
      child: CheckBoxNew(
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
    double offset = 0.2 * screenWidth * index;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.ease,
    );
  }
}
