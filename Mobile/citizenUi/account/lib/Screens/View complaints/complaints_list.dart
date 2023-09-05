import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/API/complaint_requests.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/API/complaint_requests.dart' as api;
import 'package:account/Widgets/ComaplaintCard/complaintCard.dart';


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
        appBar: myAppBar(context, 'بلاغاتي', true, screenWidth * 0.25),
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
                              id: data[index]['intComplaintId'],
                              lat: data[index]['latLng']["decLat"],
                              lng: data[index]['latLng']["decLng"],
                              i:index,
                             
                             

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


