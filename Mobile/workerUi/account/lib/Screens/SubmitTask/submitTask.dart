import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Utils/TeamMembers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/Displays/TeamViewBox.dart';
import 'package:account/API/TaskAPI/submit_task_request.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:account/Widgets/Interactive/ratingBottomSheet.dart';
// ignore_for_file: file_names

// ignore_for_file: use_build_context_synchronously

// ignore_for_file: non_constant_identifier_names
var currentPosition;


final List<String> imageList = [
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
  'img2.png',
  'img3.png',
];

List<TeamMember> teamMembersListFake = [
  TeamMember(1, 'محمد علي', false),
  TeamMember(2, 'ياسر محمد', false),
  TeamMember(3, 'عمر علي', false),
  TeamMember(4, 'أحمد ياسين', false),
];

class FinishTask extends StatefulWidget {
  final String TaskID;

  const FinishTask({
    super.key,
    required this.TaskID,
  });

  @override
  State<FinishTask> createState() => _ComaplintState();
}

class _ComaplintState extends State<FinishTask> {
  List<MediaFile> selectedMediaFiles = [];
  PageController? controller;
  GlobalKey<PageContainerState> key = GlobalKey();
  TextEditingController commentController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    selectedMediaFiles.clear();
    super.dispose();
  }

  @override
  void initState() {
    getImages(context);
    fetchAddress();
    super.initState();
    controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }


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

    if (!hasPermission || _isDisposed) return;
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!_isDisposed) {
        setState(() => currentPosition = position);
      }
    } catch (e) {}
  }

//remove , add icons
  Future<void> getImages(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (_isDisposed) return;
    if (pickedFile != null) {
      setState(() {
        selectedMediaFiles.add(
          MediaFile(
            File(pickedFile.path),
            null, // Set initial value of decLat to null
            null, // Set initial value of decLng to null
            false,
          ),
        );
      });

      await _getCurrentPosition();
      if (_isDisposed) return;
      setState(() {
        final mediaFile = selectedMediaFiles.last;
        mediaFile.decLat = currentPosition!.latitude;
        mediaFile.decLng = currentPosition!.longitude;
      });
    } else {
      // Navigator.pop(context);
    }
  }

  String address = "";
  Future<String?> fetchAddress() async {
    if (currentPosition != null) {
      final newAddress = await getAddressFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
      return newAddress;
    }
    return null;
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

  Widget stackButton(IconData icon, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ClipOval(
        child: Material(
          color: AppColor.background,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              width: 25,
              height: 25,
              child: Icon(icon, color: Colors.grey, size: 20),
            ),
          ),
        ),
      ),
    );
  }

  void removeImage(int index, BuildContext context) {
    if (index >= 0 &&
        index < selectedMediaFiles.length &&
        selectedMediaFiles.length != 1) {
      selectedMediaFiles.removeAt(index);
      setState(() {
        //selectedMediaFiles.removeAt(index);
      });
    }
    if (index < selectedMediaFiles.length) {
      controller!.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    if (selectedMediaFiles.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يجب ان يحتوي البلاغ على صورة واحدة عالأقل')),
      );
    }
  }

  void addImage(BuildContext context) {
    if (selectedMediaFiles.length <= 2) {
      getImages(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تجاوزت الحد الأقصى لالتقاط الصور')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double fieldWidth = screenWidth * 0.92;
    double fieldHeight = screenHeight * 0.2;
    //double dialogHeight = screenHeight * 0.47;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavBar1(3),
        appBar: myAppBar(context, "تسليم العمل ", false, 135),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                //--------pageView
                SizedBox(
                  height: screenHeight * 0.4,
                  child: PageIndicatorContainer(
                    align: IndicatorAlign.bottom,
                    length: selectedMediaFiles.length,
                    indicatorSpace: 10.0,
                    padding: const EdgeInsets.all(10),
                    indicatorColor: Colors.grey,
                    indicatorSelectorColor: Colors.blue,
                    shape: IndicatorShape.circle(size: 7),
                    child: PageView.builder(
                      controller: controller,
                      itemCount: selectedMediaFiles.length,
                      itemBuilder: (context, position) {
                        return Stack(
                          children: [
                            Center(
                              child: selectedMediaFiles[position].decLat ==
                                          null &&
                                      selectedMediaFiles[position].decLng ==
                                          null
                                  ? const CircularProgressIndicator.adaptive()
                                  : SizedBox(
                                      width: double.infinity,
                                      child: Image.file(
                                        selectedMediaFiles[position].file,
                                        fit: BoxFit.cover,
                                        scale: 0.1,
                                      ),
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                stackButton(Icons.add, () {
                                  addImage(context);
                                  setState(() {});
                                }),
                                stackButton(Icons.delete, () {
                                  removeImage(position, context);
                                }),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                //--------------Teams
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: AppColor.background,
                      useRootNavigator: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return ratingSheet(context);
                      },
                    );
                  },
                  child: TeamViewBox(
                    height: fieldHeight,
                    width: double.infinity,
                    boxHeight: fieldHeight * 0.55,
                    boxWidth: fieldWidth * 0.35,
                    teamMembers: teamMembersListFake,
                  ),
                ),
                //const SizedBox(height: 0,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: screenHeight * 0.25,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.main, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: commentController,
                      focusNode: textFieldFocusNode,
                      autofocus: true,
                      maxLines: null,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20.0, right: 10),
                        hintText: 'أضف تعليق ..',
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(color: AppColor.main),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                BottonContainer("استمرار", Colors.white, AppColor.main,
                    screenWidth * 0.7, context, true, null, () {
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) => buildConfirmDialog(
                  //       context,
                  //       "تأكيد العمل",
                  //       "موقع العمل",
                  //       "ش.صوفي التل.عمان",
                  //       widget.TaskID,
                  //       commentController.text,
                  //       selectedMediaFiles),
                  // );
                }),

                SizedBox(
                  height: screenHeight * 0.05,
                ),
              ])),
        ),
      ),
    );
  }
}
