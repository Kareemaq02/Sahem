import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/HelperWidgets/text.dart';
import 'package:account/API/TaskAPI/view_tasks_request.dart';
import 'package:account/Widgets/Buttons/buttonsForCards.dart';
import 'package:account/Widgets/TaskCard/timeLineWidget.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';
import 'package:account/API/TaskAPI/activate_task_request.dart';
import 'package:account/Screens/View%20tasks/task_details.dart';
// ignore_for_file: file_names


class TaskCard extends StatelessWidget {
  final String comment;
  final String type;
  final String status;
  final String date;
  final String id;
  final String deadline;
  final bool isLeader;

  const TaskCard({
    Key? key,
    required this.comment,
    required this.status,
    required this.date,
    required this.type,
    required this.id,
    required this.deadline,
    required this.isLeader,
  }) : super(key: key);

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
                  CardButtons(context, 'تفعيل', Colors.grey,
                      isLeader ? Colors.grey : AppColor.main, 0, () {
                    b.activateTask(id);
                  }),
                  SizedBox(width: screenWidth * 0.02),
                  CardButtons(context, 'معاينة', Colors.grey, AppColor.main,
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
                                return const CircularProgressIndicator();
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
                  const Spacer(),
                  text(type, AppColor.textTitle),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.7),
                  child: text("قبل 5 ساعات ", AppColor.textBlue)),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Flexible(
                child: timeLineWidget(),
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
