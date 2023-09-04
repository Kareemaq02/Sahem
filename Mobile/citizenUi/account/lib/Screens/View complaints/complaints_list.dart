import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timelines/timelines.dart';
import 'package:animations/animations.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/API/complaint_requests.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/API/complaint_requests.dart' as api;
import 'package:account/Widgets/ComaplaintCard/taskCard.dart';
import 'package:account/Widgets/Buttons/buttonsForCards.dart';
import 'package:account/Widgets/HelperWidegts/myContainer.dart';
import 'package:account/Widgets/HelperWidegts/complaintCard.dart';
import 'package:account/Widgets/ComaplaintCard/timeLineWidget.dart';
import 'package:account/Screens/View%20complaints/complaints_details.dart';
// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, duplicate_ignore, unused_element, constant_identifier_names, library_private_types_in_public_api, avoid_print

bool reminder = false;

class XDComplaintsList extends StatefulWidget {
  const XDComplaintsList({Key? key}) : super(key: key);

  @override
  _XDComplaintsListState createState() => _XDComplaintsListState();
}

class _XDComplaintsListState extends State<XDComplaintsList> {
  late List<api.ComplaintModel> complaints = [];
  getUserComplaint userComplaint = getUserComplaint();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: false,
        floatingActionButton: const CustomActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavBar1(2),
        appBar: myAppBar(context, 'بلاغاتي', true, 130),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: userComplaint.fetchComplaints(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data as List<dynamic>?;
                    return ListView.builder(
                      itemCount: data != null ? data.length : 0,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ComplaintCard2(
                              type: data![index]['strComplaintTypeAr'],
                              status: data[index]['intStatusId'],
                              date: data[index]['dtmDateCreated'].toString(),
                              id: data[index]['intComplaintId'].toString(),
                              // isReminded: data[index]['intComplaintId'],
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
