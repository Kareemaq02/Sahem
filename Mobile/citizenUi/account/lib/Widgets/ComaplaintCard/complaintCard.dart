import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/complaint_requests.dart';
import 'package:account/API/send_reminder_Request.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/Widgets/Buttons/buttonsForCards.dart';
import 'package:account/Widgets/HelperWidegts/myContainer.dart';
import 'package:account/Widgets/HelperWidegts/complaintCard.dart';
import 'package:account/Widgets/ComaplaintCard/timeLineWidget.dart';
import 'package:account/Screens/View%20complaints/complaints_details.dart';
// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print

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
    fetchAddress();
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
                  CardButtons(context, 'تذكير', Colors.grey, Colors.white, 0,
                      Colors.grey, () {
                    a.comaplintReminder(widget.id, context);
                  }),
                  SizedBox(width: screenWidth * 0.02),
                  CardButtons(context, 'معاينة', Colors.white, AppColor.main, 0,
                      Colors.grey.shade300, () {
                    print(widget.status);
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
                                return Center(
                                  child: text('لا يتوفر شريط زمني لهذا البلاغ',
                                      AppColor.main),
                                );
                              } else if (snapshot.hasData) {
                                List<ComplaintModel> tasks = snapshot.data!;
                                return ComplaintDetailsScreen(
                                    complaints: tasks, address: address);
                              } else {
                                return text('ا يتوفر شريط زمني لهذا البلاغ',
                                    AppColor.main);
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
                child: Text(formatTimeDifference(widget.date),
                    style: const TextStyle(
                      color: Color(0xff92a5c6),
                      fontSize: 10,
                      fontFamily: 'DroidArabicKufi',
                    )),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Flexible(
                child: timeLineWidget(widget.status),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: SizedBox(
                  width: screenWidth * 1,
                  child: Text(
                    address,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontFamily: 'DroidArabicKufi',
                      fontSize: 10,
                      color: AppColor.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    textWidthBasis: TextWidthBasis.values[1],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
