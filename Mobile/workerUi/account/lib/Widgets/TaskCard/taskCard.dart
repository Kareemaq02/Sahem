import 'package:account/API/login_request.dart';
import 'package:account/Utils/NaviTranstion.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/HelperWidgets/text.dart';
import 'package:account/API/TaskAPI/view_tasks_request.dart';
import 'package:account/Screens/CurrentTask/currentTask.dart';
import 'package:account/Widgets/Buttons/buttonsForCards.dart';
import 'package:account/Widgets/TaskCard/timeLineWidget.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';
import 'package:account/API/TaskAPI/activate_task_request.dart';
import 'package:account/Screens/View%20tasks/task_details.dart';
// ignore_for_file: file_names

class TaskCard extends StatelessWidget {
  final String comment;
  final String type;
  final int status;
  final String date;
  final String id;
  final String deadline;
  final bool isLeader;
  final bool blnIsActive;

  const TaskCard(
      {Key? key,
      required this.comment,
      required this.status,
      required this.date,
      required this.type,
      required this.id,
      required this.deadline,
      required this.isLeader,
      required this.blnIsActive})
      : super(key: key);

  void _showSnackbar(BuildContext context) {
    SnackBar snackBar = const SnackBar(
      content: Center(
        child: Text(
          "يوجد مهمة مفعلة للفريق الحالي",
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'DroidArabicKufi'),
        ),
      ),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    TaskActivation b = TaskActivation();

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: myContainer(
        screenHeight * 0.24,
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CardButtons(context, 'معاينة', AppColor.main, AppColor.main,
                      screenWidth * 0.12, () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          WorkerTask a = WorkerTask();
                          Future<List<TaskModel>> complaintFuture =
                              a.getWorkerTasksDetails(id);
                          return FutureBuilder<List<TaskModel>>(
                            future: complaintFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: AppColor.background,
                                );
                              } else if (snapshot.hasError) {
                                return text(
                                    'Error: ${snapshot.error}', AppColor.main);
                              } else if (snapshot.hasData) {
                                List<TaskModel> tasks = snapshot.data!;
                                return ComplaintDetailsScreen(
                                  tasks: tasks,
                                );
                              } else {
                                return text(
                                    'Error: ${snapshot.error}', AppColor.main);
                              }
                            },
                          );
                        },
                      ),
                    );
                  }),
                  SizedBox(width: screenWidth * 0.02),
                  Visibility(
                    visible: getUserData().userType.contains("teamleader"),
                    child: CardButtons(
                        context,
                        blnIsActive ? "مفعلة" : 'تفعيل',
                        blnIsActive ? Colors.grey : AppColor.main,
                        blnIsActive ? Colors.grey : AppColor.main,
                        0, () async {
                      var statusCode =
                          getUserData().userType.contains("teamleader")
                              ? b.activateTask(id)
                              : null;

                      if (await statusCode == 200) {
                        naviTransition(context, const CurrentTask());
                      } else {
                        _showSnackbar(context);
                      }
                    }),
                  ),
                  const Spacer(),
                  text(type, AppColor.textTitle),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: status == 4 || status == 5,
                    child: Container(
                        width: screenWidth * 0.13,
                        height: screenWidth * 0.055,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: AppColor.main, width: 2)),
                        child: Center(
                          child: Text(
                            statusList[status - 1].name,
                            style: const TextStyle(
                              fontSize: 8,
                              fontFamily: 'DroidArabicKufi',
                              color: AppColor.main,
                            ),
                          ),
                        )),
                  ),
                  text("قبل 5 ساعات ", AppColor.textBlue),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Flexible(
                child: timeLineWidget(status),
              ),
              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.6),
                child: text("ش ,وصفي التل , عمان", AppColor.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
