import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/HelperWidgets/text.dart';
import 'package:account/Screens/CurrentTask/mapView.dart';
import 'package:account/Screens/CurrentTask/googleMap.dart';
import 'package:account/Screens/SubmitTask/submitTask.dart';
import 'package:account/API/TaskAPI/get_activated_task.dart';
import 'package:account/Widgets/Buttons/buttonsForCards.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';

class CurrentTask extends StatefulWidget {
  const CurrentTask({Key? key}) : super(key: key);

  @override
  _CurrentTaskState createState() => _CurrentTaskState();
}

class _CurrentTaskState extends State<CurrentTask> {
  ActivatedTaskModel? activatedTask;
  String address = "";

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    _loadData();
  }

  // ... Existing code ...

  Future<void> _loadData() async {
    try {
      final activatedTask = await ActivatedTask().getActivatedTask();
      setState(() {
        this.activatedTask = activatedTask;
        fetchAddress(activatedTask.latLng.decLat, activatedTask.latLng.decLng);
      });
    } catch (e) {
      // Handle any errors that occur during data loading
      print("Error loading data: $e");
    }
  }

  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('تم تعطيل خدمة الموقع الحالي. الرجاء تفعيل الخدمة')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم رفض أذونات الموقع')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم رفض أذونات الموقع بشكل دائم.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      //  debugPrint(e);
    });
  }

  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lng,
        localeIdentifier: 'ar',
      );

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks[0];
        final String? address = placemark.street;
        return address;
      } else {
        return '';
      }
    } catch (e) {
      return '$e';
    }
  }

  Future<void> fetchAddress(double lat, double lng) async {
    address = (await getAddressFromCoordinates(lat, lng))!;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar1(3),
      appBar: myAppBar(context, 'المهمة المفعلة', false, screenWidth * 0.5),
      body: activatedTask == null
          ? activatedStatus != 400
              ? const Center(
                  child: CircularProgressIndicator(
                  color: AppColor.main,
                ))
              : const Center(
                  child: Text(
                    'لا يوجد مهمة مفعلة',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.main,
                      fontFamily: 'DroidArabicKufi',
                    ),
                  ),
                )
          : Padding(
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
                      child: FullMap(
                        lat: activatedTask!.latLng.decLat,
                        lng: activatedTask!.latLng.decLng,
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
                                      AppColor.main,
                                      AppColor.main,
                                      screenWidth * 0.6,
                                      () async {
                                        await _getCurrentPosition();
                                        navigateToGoogleMaps(
                                          _currentPosition!.altitude,
                                          _currentPosition!.longitude,
                                          activatedTask!.latLng.decLat,
                                          activatedTask!.latLng.decLng,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    Visibility(
                                      visible: getUserData()
                                          .userType
                                          .contains("teamleader"),
                                      child: CardButtons(
                                          context,
                                          'تسليم المهمة',
                                          activatedTask!.blnIsLeader
                                              ? AppColor.main
                                              : Colors.grey,
                                          activatedTask!.blnIsLeader
                                              ? AppColor.main
                                              : Colors.grey,
                                          screenWidth * 0.6, () {
                                        // activatedTask!.blnIsLeader
                                        //     ?

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FinishTask(
                                                      TaskID: activatedTask!
                                                          .taskId
                                                          .toString(),
                                                    )));
                                        // : null;
                                      }),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: screenWidth * 0.01),
                                      child: text(activatedTask!.strTypeNameAr,
                                          AppColor.textBlue),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: screenWidth * 0.70),
                                  child: text(
                                      activatedTask!.activatedDate
                                          .substring(0, 10),
                                      AppColor.textBlue),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: screenWidth * 0.55,
                                      top: screenHeight * 0.02),
                                  child: text(
                                      activatedTask!.strComment.isEmpty
                                          ? "اعمال صيانة دورية فالمنطقة"
                                          : activatedTask!.strComment,
                                      AppColor.textBlue),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(
                                      right: screenWidth * 0.5,
                                      top: screenHeight * 0.04),
                                  child: text(address, AppColor.secondary),
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
