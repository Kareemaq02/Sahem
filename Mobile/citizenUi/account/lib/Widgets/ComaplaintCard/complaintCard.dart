import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/complaint_requests.dart';
import 'package:account/API/send_reminder_Request.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/Widgets/Buttons/buttonsForCards.dart';
import 'package:account/Widgets/HelperWidegts/myContainer.dart';
import 'package:account/Widgets/HelperWidegts/complaintCard.dart';
import 'package:account/Widgets/ComaplaintCard/timeLineWidget.dart';
import 'package:account/Screens/View%20complaints/complaints_details.dart';

class ComplaintCard2 extends StatefulWidget {
  final String type;
  final int status;
  final String date;
  final int id;
  final double lat;
  final double lng;
  final int i;
  //final String pic;

  const ComplaintCard2({
    Key? key,
    required this.status,
    required this.date,
    required this.type,
    required this.id,
    required this.lat,
    required this.lng,
    required this.i,
    // required this.pic
  }) : super(key: key);

  @override
  _ComplaintCard2sState createState() => _ComplaintCard2sState();
}

class _ComplaintCard2sState extends State<ComplaintCard2> {
  @override
  void initState() {
    super.initState();
    // fetchAddress();
  }

  List<ComaplintSatus> statusList = [];

  getUserComplaint a = getUserComplaint();

  Future<void> fetchComplaintStatusList() async {
    try {
      statusList = await a.fetchComaplintStatus(widget.id);
    } catch (e) {
      // Handle the exception/error here
      print('Failed to fetch complaint statuses: $e');
    }
  }


  String address = "";

  Future<void> fetchAddress() async {
    address = (await getAddressFromCoordinates(widget.lat, widget.lng))!;
    print(address);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ComapalintReminder a = ComapalintReminder();
    getUserComplaint b = getUserComplaint();

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
                  CardButtons(context, 'تذكير', Colors.grey, AppColor.main, 0,
                      () {
                    a.comaplintReminder(widget.id, context);
                  }),
                  SizedBox(width: screenWidth * 0.02),
                  CardButtons(context, 'معاينة', Colors.grey, AppColor.main,
                      screenWidth * 0.12, () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          Future<List<ComplaintModel>> complaintFuture =
                              b.getComplaintById(widget.id);
                          return FutureBuilder<List<ComplaintModel>>(
                            future: complaintFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (snapshot.hasError) {
                                return text(
                                    'Error: ${snapshot.error}', AppColor.main);
                              } else if (snapshot.hasData) {
                                List<ComplaintModel> tasks = snapshot.data!;
                                return ComplaintDetailsScreen(
                                  complaints: tasks,
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
                  text(widget.type, AppColor.textTitle),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.7),
                  child: text("قبل 5 ساعات ", AppColor.textBlue)),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Flexible(
                child: timeLineWidget(2),
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
