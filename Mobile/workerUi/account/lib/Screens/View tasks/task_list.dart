import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/TaskCard/taskCard.dart';
import 'package:account/API/TaskAPI/view_tasks_request.dart';
// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, duplicate_ignore, unused_element, constant_identifier_names, library_private_types_in_public_api, avoid_print


class XDTasksList extends StatefulWidget {
  const XDTasksList({Key? key}) : super(key: key);

  @override
  _XDTasksListState createState() => _XDTasksListState();
}

class _XDTasksListState extends State<XDTasksList> {
  WorkerTask a = WorkerTask();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: false,
      
        bottomNavigationBar: BottomNavBar1(2),
        appBar: myAppBar(context, 'الاعمال', true, 130),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: a.fetchUserTasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data;
                    return ListView.builder(
                      itemCount: data != null ? data.length : 0,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            TaskCard(
                              comment: data![index]['strComment'].toString(),
                              type: data[index]['strTypeNameAr'].toString(),
                              status: data[index]['intTaskStatusId'],
                              date: data[index]['activatedDate'].toString(),
                              id: data[index]['taskId'].toString(),
                              isLeader: data[index]['blnIsTaskLeader'],
                              deadline: data[index]['deadlineDate'],
                              
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ));
  }
}






