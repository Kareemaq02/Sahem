import 'package:account/API/TaskAPI/GetAdminTasks.dart';
import 'package:account/Screens/TaskEvaluation/TaskRating.dart';
import 'package:account/Utils/DateFormatter.dart';
import 'package:account/Utils/NaviTranstion.dart';
import 'package:account/Widgets/Bars/NavBarAdmin.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/HelperWidgets/Base64ImageDisplay.dart';
import 'package:account/Widgets/HelperWidgets/Loader.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/HelperWidgets/rowInfo.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';

class TaskEvaluation extends StatefulWidget {
  const TaskEvaluation({super.key});

  @override
  _TaskEvaluationState createState() => _TaskEvaluationState();
}

class _TaskEvaluationState extends State<TaskEvaluation> {
  // Render Vars
  bool isLoading = false;
  int selectedIndex = 0;

  // API vars
  late Future<List<TaskEvaluationModel>> tasksRequest;
  List<TaskEvaluationModel> tasks = [];
  int pageNumber = 1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getTasksList();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreTasks();
    }
  }

  void getTasksList() async {
    tasksRequest = AdminTasksRequest().getAdminTasks(pageNumber);
    tasks = await tasksRequest;
  }

  void loadMoreTasks() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      List<TaskEvaluationModel> moreTasks =
          await AdminTasksRequest().getAdminTasks(++pageNumber);

      setState(() {
        tasks.addAll(moreTasks);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavBarAdmin(2),
      appBar: myAppBar(context, 'تقييم المهام', false, screenHeight * 0.28),
      body: FutureBuilder<List<TaskEvaluationModel>>(
        future: tasksRequest,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<TaskEvaluationModel> tasksList =
              tasks.length > 1 ? tasks : snapshot.data!;
          if (tasksList.isEmpty) {
            return const Center(
                child: TitleText(text: "لا يوجد مهام فالوقت الحالي."));
          }
          return SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ...List.generate(
                  tasksList.length,
                  (index) {
                    TaskEvaluationModel task = tasksList[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.02),
                      child: myContainer(
                        screenHeight * 0.7,
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.01),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.45,
                                child: PageIndicatorContainer(
                                  align: IndicatorAlign.bottom,
                                  length: task.lstMedia.length,
                                  indicatorSpace: 10.0,
                                  padding: const EdgeInsets.all(15),
                                  indicatorColor: Colors.grey,
                                  indicatorSelectorColor: Colors.blue,
                                  shape: IndicatorShape.circle(size: 7),
                                  child: PageView.builder(
                                    itemCount: task.lstMedia.length,
                                    itemBuilder: (context, position) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenHeight * 0.01,
                                            horizontal: screenWidth * 0.02),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColor.background,
                                            ),
                                            child: task.lstMedia[position]
                                                    .base64Data.isNotEmpty
                                                ? Stack(
                                                    children: [
                                                      SizedBox(
                                                        height: double.infinity,
                                                        child:
                                                            Base64ImageDisplay(
                                                          task
                                                              .lstMedia[
                                                                  position]
                                                              .base64Data,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              top:
                                                                  screenHeight *
                                                                      0.01),
                                                          child: Container(
                                                            height:
                                                                screenHeight *
                                                                    0.05,
                                                            width: screenWidth *
                                                                0.10,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      75,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  blurRadius: 5,
                                                                  offset: Offset(
                                                                      0,
                                                                      screenHeight *
                                                                          0.05 *
                                                                          0.05),
                                                                )
                                                              ],
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color:
                                                                      AppColor
                                                                          .line,
                                                                  width: 1),
                                                            ),
                                                            child: Center(
                                                              child: Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: screenHeight *
                                                                        0.005),
                                                                child:
                                                                    TitleText(
                                                                  text: task
                                                                      .lstMedia[
                                                                          position]
                                                                      .intComplaintId
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const Center(
                                                    child: TitleText(
                                                        text: "لا يوجد صورة"),
                                                  ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03),
                                child: Column(
                                  children: [
                                    RowInfo(
                                      "رقم المهمة",
                                      task.taskId.toString(),
                                    ),
                                    RowInfo(
                                      "نوع المهمة",
                                      task.strTypeNameAr.toString(),
                                    ),
                                    RowInfo(
                                      "موقع المهمة",
                                      "${task.latLng.lng} ,${task.latLng.lat}",
                                    ),
                                    RowInfo(
                                      "تاريخ الاضافة",
                                      formatDate(
                                        DateTime.parse(task.scheduledDate),
                                      ),
                                    ),
                                    RowInfo(
                                      "تاريخ الإنتهاء",
                                      formatDate(
                                        DateTime.parse(task.finishedDate),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.008,
                              ),
                              StyledButton(
                                text: "تقييم",
                                fontSize: 14,
                                onPressed: () {
                                  naviTransition(
                                    context,
                                    TaskRating(
                                      taskId: task.taskId,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                isLoading
                    ? const Loader()
                    : SizedBox(
                        height: screenHeight * 0.02,
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
