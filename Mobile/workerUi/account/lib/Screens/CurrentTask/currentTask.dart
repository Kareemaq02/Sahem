import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/HelperWidgets/text.dart';
import 'package:account/Screens/CurrentTask/mapView.dart';
import 'package:account/Screens/CurrentTask/googleMap.dart';
import 'package:account/Screens/SubmitTask/submitTask.dart';
import 'package:account/Widgets/Buttons/buttonsForCards.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';
// ignore_for_file: file_names

// ignore_for_file: library_private_types_in_public_api


class CurrentTask extends StatefulWidget {
  const CurrentTask({Key? key}) : super(key: key);

  @override
  _XDPublicFeed1State createState() => _XDPublicFeed1State();
}

class _XDPublicFeed1State extends State<CurrentTask> {
  var reminder = false;
  var type = "";
  bool teamLeader = true;
  double currentLat = 37.7749; // User's current latitude
  double currentLng = -122.4194; // User's current longitude
  double destinationLat = 37.3352; // Destination latitude
  double destinationLng = -122.0477; // Destination longitude

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
      bottomNavigationBar: BottomNavBar1(3),
      appBar: myAppBar(context, ' العمل الحالي ', false, screenWidth * 0.4),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.white,
            height: screenHeight * 0.90,
            child: Column(children: [
              //mapview
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: screenHeight * 0.6,
                child: const FullMap(),
              ),

              //container to view data
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.15, right: screenWidth * 0.15),
                child: const Divider(
                  color: Colors.yellow,
                  endIndent: 2,
                  indent: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: myContainer(
                    screenHeight * 0.22,
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Column(
                        children: [
                          // const SizedBox(height: 10),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CardButtons(
                                context,
                                'اتجاهات',
                                Colors.grey,
                                AppColor.main,
                                screenWidth * 0.6,
                                () {
                                  navigateToGoogleMaps(currentLat, currentLng,
                                      destinationLat, destinationLng);
                                },
                              ),
                              const SizedBox(width: 10),
                              CardButtons(
                                  context,
                                  'معاينة',
                                  Colors.grey,
                                  teamLeader ? AppColor.main : Colors.grey,
                                  screenWidth * 0.6, () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const FinishTask(
                                              TaskID: '',
                                            )));
                              }),
                              const Spacer(),
                              Text(
                                type,
                                style: TextStyle(
                                  color: AppColor.textTitle,
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: screenWidth * 0.01),
                                child: text(
                                    " مخلفات اعمال بناء", AppColor.textBlue),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.65),
                            child: text("مارس-15-2023", AppColor.textBlue),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.45,
                                top: screenHeight * 0.02),
                            child: text("اعمال صيانة دورية فالمنطقة",
                                AppColor.textBlue),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                right: screenWidth * 0.56,
                                top: screenHeight * 0.05),
                            child: text("ش.وصفي التل.عمان", AppColor.secondary),
                          ),
                        ],
                      ),
                    )),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
