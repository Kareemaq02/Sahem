import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Utils/NaviTranstion.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Widgets/Bars/NavBarAdmin.dart';
import 'package:account/Screens/Results/FailurePage.dart';
import 'package:account/Screens/Results/SuccessPage.dart';
import 'package:account/Widgets/HelperWidgets/Loader.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/Displays/TeamViewBox.dart';
import 'package:account/Widgets/HelperWidgets/rowInfo.dart';
import 'package:account/API/TaskAPI/Get_A_Task_Request.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/Interactive/RatingWidget.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Screens/TaskEvaluation/TaskIncomplete.dart';

class TaskEvaluation extends StatefulWidget {
  final int taskId;
  const TaskEvaluation({super.key, required this.taskId});

  @override
  _TaskEvaluationState createState() => _TaskEvaluationState();
}

class _TaskEvaluationState extends State<TaskEvaluation> {
  // API vars
  late Future<TaskDetails> taskDetailsRequest;
  late TaskDetails taskDetails;

  // Request Vars
  int statusChoice = 1;
  double rating = 2.5;

  @override
  void initState() {
    super.initState();
    getTaskDetails(widget.taskId);
  }

  void getTaskDetails(int taskId) async {
    taskDetailsRequest = TaskDetailsRequest().getTaskDetails(taskId);
    taskDetails = await taskDetailsRequest;
  }

  void _sendRequest() async {
    //use dio if http doesn't work
    if (statusChoice == 2) {
      naviTransition(
          context,
          TaskIncomplete(
            taskId: widget.taskId,
          ));
      return;
    }
    Map<String, dynamic> data = {
      'decRating': rating,
      'taskId': widget.taskId,
    };
    print(data);
    // final response = await request(data)
    // var statusCode = response.statusCode;
    var statusCode = 200;
    if (statusCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: const SuccessPage(
              text: 'تم تقييم المهمه بنجاح!',
            ),
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: const FailurePage(
              text: 'لم يتم تقييم المهمه!',
            ),
          ),
        ),
      );
    }
  }
  //

  final List<String> imageList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double fieldWidth = screenWidth * 0.92;
    double fieldHeight = screenHeight * 0.2;
    double dialogHeight = screenHeight * 0.47;

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavBarAdmin(2),
      appBar: myAppBar(context, 'اضافة عمل', false, screenHeight * 0.28),
      body: FutureBuilder<TaskDetails>(
        future: taskDetailsRequest,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                myContainer(
                  screenHeight * 0.5,
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.01),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.33,
                          child: PageIndicatorContainer(
                            align: IndicatorAlign.bottom,
                            length: imageList.length,
                            indicatorSpace: 10.0,
                            padding: const EdgeInsets.all(15),
                            indicatorColor: Colors.grey,
                            indicatorSelectorColor: Colors.blue,
                            shape: IndicatorShape.circle(size: 7),
                            child: PageView.builder(
                              itemCount: imageList.length,
                              itemBuilder: (context, position) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.01,
                                      horizontal: screenWidth * 0.02),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor.background,
                                      ),
                                      child: Image.network(
                                        imageList[position],
                                        scale: 0.1,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        RowInfo(
                          "رقم المهمه",
                          taskDetails.intTaskID.toString(),
                        ),
                        RowInfo(
                          "نوع المهمه",
                          taskDetails.strTypeNameAr.toString(),
                        ),
                        RowInfo(
                          "تاريخ الاضافة ",
                          taskDetails.dtmCreatedDate
                              .toString()
                              .substring(0, 10),
                        ),
                        RowInfo(
                          "تاريخ الانتهاء ",
                          taskDetails.dtmFinishedDate
                              .toString()
                              .substring(0, 10),
                        ),
                        RowInfo(
                          "موقع المهمه",
                          "ش.وصفي التل ,عمان",
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    TeamViewBox(
                      height: fieldHeight,
                      width: double.infinity,
                      boxHeight: fieldHeight * 0.65,
                      boxWidth: fieldWidth * 0.3,
                      teamMembers: taskDetails.workersList,
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    SizedBox(
                      height: fieldHeight / 4,
                      width: fieldWidth / 3,
                      child: StyledButton(
                        text: "تقييم",
                        fontSize: fieldHeight / 3 * 0.3,
                        onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext builder) {
                              // reset dialog
                              dialogHeight = screenHeight * 0.28;
                              statusChoice = 1;
                              rating = 2.5;
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Container(
                                  height: dialogHeight,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Title
                                        SizedBox(
                                          height: screenHeight * 0.08,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              top: screenHeight * 0.01,
                                            ),
                                            child: const TitleText(
                                              text: "التقييم",
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom: screenHeight * 0.02,
                                          ),
                                          child: Column(
                                            children: [
                                              // Stars
                                              RatingWidget(
                                                rating: rating,
                                                iconSize: fieldWidth / 10,
                                                onChanged: (newRating) {
                                                  setState(() {
                                                    rating = newRating;
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.01,
                                              ),
                                              // CheckBoxes
                                              StatefulBuilder(builder: (context,
                                                  setStateCheckBoxes) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        StyledCheckBox(
                                                            text: "غير مكتمل",
                                                            fontSize: 14,
                                                            isChecked:
                                                                statusChoice ==
                                                                    2,
                                                            onChanged: () {
                                                              setStateCheckBoxes(
                                                                  () =>
                                                                      statusChoice =
                                                                          2);
                                                            }),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              0.05,
                                                        ),
                                                        StyledCheckBox(
                                                            text: "مكتمل",
                                                            fontSize: 14,
                                                            isChecked:
                                                                statusChoice ==
                                                                    1,
                                                            onChanged: () {
                                                              setStateCheckBoxes(
                                                                  () =>
                                                                      statusChoice =
                                                                          1);
                                                            }),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }),
                                              SizedBox(
                                                height: screenHeight * 0.01,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: screenHeight * 0.01),
                                                child: SizedBox(
                                                  height: fieldHeight / 4,
                                                  width:
                                                      fieldWidth * 0.75 * 0.5,
                                                  child: StyledButton(
                                                    text: "موافق",
                                                    fontSize: fieldWidth *
                                                        0.75 *
                                                        0.5 *
                                                        0.12,
                                                    onPressed: _sendRequest,
                                                  ),
                                                ),
                                              ),
                                              statusChoice == 2
                                                  ? const Text(
                                                      "سيتم اعادة ارسال المهمه**",
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'DroidArabicKufi',
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
