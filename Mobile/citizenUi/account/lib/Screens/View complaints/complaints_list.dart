import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/API/complaint_requests.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/API/complaint_requests.dart' as api;
import 'package:account/Widgets/ComaplaintCard/complaintCard.dart';
// ignore_for_file: unused_local_variable, unnecessary_null_comparison



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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: false,
        floatingActionButton: const CustomActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavBar1(2),
        appBar: myAppBar(context, 'بلاغاتي', false, screenWidth * 0.65),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                displacement: 100,
                backgroundColor: AppColor.background,
                color: AppColor.main,
                strokeWidth: 3,
                //triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  userComplaint.fetchComplaints();
                  setState(() {});
                },
                child: FutureBuilder(
                  future: userComplaint.fetchComplaints(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data as List<dynamic>?;
                      var revList = data!.reversed.toList();
                      return ListView.builder(
                        //reverse: true,
                        itemCount: revList != null ? revList.length : 0,
                        itemBuilder: (context, index) {
                          if (revList.isEmpty) {
                            return Center(
                                child: text(
                                    "لا يوجد بلاغات مسجلة ", AppColor.main));
                          }
                          return Column(
                            children: [
                              ComplaintCard2(
                                type: revList[index]['strComplaintTypeAr'],
                                status: revList[index]['intStatusId'],
                                date:
                                    revList[index]['dtmDateCreated'].toString(),
                                id: revList[index]['intComplaintId'],
                                lat: revList[index]['latLng']["decLat"],
                                lng: revList[index]['latLng']["decLng"],
                                i: index,
                                isRated: revList[index]['blnIsRated'],
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
            ),
          ],
        ));
  }

}


