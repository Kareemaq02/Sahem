import 'package:account/API/TaskAPI/Get_A_Task_Request.dart';
import 'package:account/Screens/Results/FailurePage.dart';
import 'package:account/Screens/Results/SuccessPage.dart';
import 'package:account/Utils/DateFormatter.dart';
import 'package:account/Utils/TeamMembers.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Widgets/Displays/TeamViewBox.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/Interactive/DateRangeField.dart';
import 'package:account/Widgets/Interactive/FormTextField.dart';
import 'package:account/Widgets/Interactive/RatingWidget.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 7));

  // Request Vars
  TextEditingController commentController = TextEditingController();
  int statusChoice = 1;
  double rating = 2.5;

  @override
  void initState() {
    super.initState();
    getTaskDetails(widget.taskId);
  }

  // API Functions

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    PickerDateRange dateRange = args.value;
    if (dateRange.endDate != null) {
      setState(() {
        startDate = dateRange.startDate!;
        endDate = dateRange.endDate!;
      });
    }
  }

  void getTaskDetails(int taskId) async {
    // taskDetailsRequest = TaskDetailsRequest().getTaskDetails(taskId);
    taskDetailsRequest = Future.delayed(
      const Duration(milliseconds: 300),
      () => TaskDetails(
        intTaskID: 1,
        decCost: 2421.21,
        decUserRating: 0,
        dtmCreatedDate:
            formatDate(DateTime.now().subtract(const Duration(days: 7))),
        dtmScheduledDate:
            formatDate(DateTime.now().subtract(const Duration(days: 5))),
        dtmActivatedDate:
            formatDate(DateTime.now().subtract(const Duration(days: 4))),
        dtmFinishedDate:
            formatDate(DateTime.now().subtract(const Duration(days: 2))),
        dtmDeadlineDate:
            formatDate(DateTime.now().subtract(const Duration(days: 1))),
        dtmLastModifiedDate:
            formatDate(DateTime.now().subtract(const Duration(days: 2))),
        strAdminFirstName: "محمد",
        strAdminLastName: "بسام",
        strComment: "",
        strTypeNameAr: "مبعثرات حول الحاوية",
        strTypeNameEn: "Scatter waste",
        strTaskStatus: "completed",
        workersList: <TeamMember>[
          TeamMember(1, "محمد بسام", false),
          TeamMember(2, "عمر احمد", true),
          TeamMember(3, "طلال بلال", false),
          TeamMember(4, "سيف محمد", false),
        ],
        lstMedia: List.empty(),
      ),
    );
    taskDetails = await taskDetailsRequest;
  }

  void _sendRequest() async {
    //use dio if http doesn't work
    Map<String, dynamic> data = {
      'scheduledDate': startDate,
      'deadlineDate': endDate,
      'strComment': commentController.text,
      'taskId': widget.taskId,
    };
    print(data);
    // final response = await request(data)
    // if (response.statusCode == 200) {

    var statusCode = 200;
    // var statusCode = 400;
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
      bottomNavigationBar: BottomNavBar1(0),
      appBar: myAppBar(context, 'اضافة عمل', false, screenHeight * 0.28),
      body: FutureBuilder<TaskDetails>(
        future: taskDetailsRequest,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                Column(
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
                            return Container(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                              child: Container(
                                //height: ,
                                color: AppColor.background,
                                child: Image.network(
                                  imageList[
                                      position], // Use the correct image path here
                                  scale: 0.1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Mycontainer(
                      screenHeight * 0.2,
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.01),
                        child: Column(
                          children: [
                            RowInfo(
                                "رقم المهمه", taskDetails.intTaskID.toString()),
                            RowInfo("نوع المهمه",
                                taskDetails.strTypeNameAr.toString()),
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
                  ],
                ),
                Column(
                  children: [
                    TeamViewBox(
                      height: fieldHeight,
                      width: fieldWidth,
                      boxHeight: fieldHeight * 0.65,
                      boxWidth: fieldWidth * 0.29,
                      teamMembers: taskDetails.workersList,
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    SizedBox(
                      height: fieldHeight / 3,
                      width: fieldWidth / 2,
                      child: StyledButton(
                        text: "تقييم",
                        fontSize: fieldHeight / 3 * 0.4,
                        onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext builder) {
                              // reset dialog
                              statusChoice = 1;
                              rating = 2.5;
                              return StatefulBuilder(
                                  builder: (context, setStateDialog) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Container(
                                    height: dialogHeight,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30)),
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
                                                StatefulBuilder(builder:
                                                    (context,
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
                                                                setStateDialog(() =>
                                                                    dialogHeight =
                                                                        screenHeight *
                                                                            0.555);
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
                                                                setStateDialog(() =>
                                                                    dialogHeight =
                                                                        screenHeight *
                                                                            0.47);
                                                              }),
                                                        ],
                                                      ),
                                                      statusChoice == 2
                                                          ? Column(
                                                              children: [
                                                                const Text(
                                                                  "**سيتم اعادة ارسال المهمه ",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  textDirection:
                                                                      TextDirection
                                                                          .rtl,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            219,
                                                                            60,
                                                                            68),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'DroidArabicKufi',
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: screenHeight *
                                                                          0.01),
                                                                  child:
                                                                      DateRangeField(
                                                                    height:
                                                                        fieldHeight /
                                                                            4,
                                                                    width:
                                                                        fieldWidth *
                                                                            0.75,
                                                                    onSelectionChanged:
                                                                        _onSelectionChanged,
                                                                    initialRange:
                                                                        PickerDateRange(
                                                                            startDate,
                                                                            endDate),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  );
                                                }),
                                                SizedBox(
                                                  height: screenHeight * 0.01,
                                                ),
                                                // Comment Box
                                                FormTextField(
                                                  height: fieldHeight,
                                                  width: fieldWidth * 0.75,
                                                  controller: commentController,
                                                  hintText: "اضف تعليق",
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
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
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

Widget RowInfo(title, value) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColor.main,
            fontFamily: 'DroidArabicKufi',
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColor.secondary,
            fontFamily: 'DroidArabicKufi',
            fontSize: 10,
          ),
        ),
      ],
    ),
  );
}
