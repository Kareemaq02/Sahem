import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Utils/TeamMembers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:account/Widgets/Popup/popup.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/API/TeamsAPI/GetTeamMembers.dart';
import 'package:account/Widgets/HelperWidgets/Loader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:account/API/TaskAPI/view_tasks_request.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/API/TaskAPI/submit_task_request.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:account/Widgets/Displays/TeamMemberDisplay.dart';
import 'package:account/Widgets/Displays/TeamMemberAnalyticsDisplay.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

// ignore_for_file: file_names

// ignore_for_file: use_build_context_synchronously

// ignore_for_file: non_constant_identifier_names
var currentPosition;
List<TeamMember> teamMembers = [];
double ratingIntial = 2.5;

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
  final GetTeamMembersRequest _memeber = GetTeamMembersRequest();
  List<MediaFile> selectedMediaFiles = [];
  PageController? controller;
  GlobalKey<PageContainerState> key = GlobalKey();
  TextEditingController commentController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  List<WorkerRating> ratings = [];
  List<TaskModel> taskDetailsList = [];

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    selectedMediaFiles.clear();
    ratings.clear;
    super.dispose();
  }

  @override
  void initState() {
    //getImages(context);
    fetchAddress();
    super.initState();
    controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    getMemers();
    getDetails();
  }

  void getMemers() async {
    teamMembers = await _memeber.getTeamMembersByLeader(1);
  }

  WorkerTask _task = WorkerTask();

  void getDetails() async {
    taskDetailsList = await _task.getWorkerTasksDetails(widget.TaskID);
  }

//--------Location permissions -----------------------------------
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
  Future<void> getImages(BuildContext context, intComplaintId) async {
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
              intComplaintId),
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

//-----Page view widgets------------------------------------
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

  // void addImage(BuildContext context) {
  //   if (selectedMediaFiles.length <= 2) {
  //     getImages(context);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('تجاوزت الحد الأقصى لالتقاط الصور')),
  //     );
  //   }
  // }

  //--------------Rating Widget bottomSheet
  Widget ratingSheet(BuildContext context, TeamMember teamMember, index) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              teamMember.strName,
              style: const TextStyle(
                  color: AppColor.textBlue,
                  fontFamily: 'DroidArabicKufi',
                  fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RatingBar.builder(
            initialRating: ratingIntial,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: AppColor.main),
            onRatingUpdate: (rating) {
              setState(() {
                ratings[index].decRating = rating;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double fieldHeight = screenHeight * 0.2;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavBar1(3),
        appBar: myAppBar(context, "تسليم العمل ", false, screenWidth * 0.5),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              //--------pageView-----------------------------------

              Container(
                height: screenHeight * 0.35,
                width: double.infinity,
                child: FutureBuilder(
                  future: _task.getWorkerTasksDetails(widget.TaskID),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      List<bool> showMediaList = List.generate(
                        data != null ? data.first.lstMediaBefore.length : 0,
                        (index) => false,
                      );

                      return ListView.builder(
                        itemExtent: screenWidth * 1,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            data != null ? data.first.lstMediaBefore.length : 0,
                        itemBuilder: (context, index) {
                          if (selectedMediaFiles.isNotEmpty &&
                              selectedMediaFiles.length > index) {
                            // Display the taken photo using Image widget
                            return SizedBox(
                              width: double.infinity,
                              child: Image.file(
                                selectedMediaFiles[index].file,
                                fit: BoxFit.cover,
                                scale: 0.1,
                              ),
                            );
                          } else {
                            // Display the camera capture UI
                            return InkWell(
                              onTap: () {
                               
                                getImages(
                                    context,
                                    data[index].lstMediaBefore[index].intComplaintId,
                                       );
                                setState(() {
                                  // Toggle the visibility of media for the tapped item
                                  showMediaList[index] = !showMediaList[index];
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 35,
                                    ),
                                    TitleText(
                                      text:
                                          "التقط صورة لبلاغ ${data![index].strTypeNameAr}",
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              //--------------Teams--------------------------------
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "فريق العمل",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'DroidArabicKufi',
                        color: AppColor.textTitle),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: FutureBuilder<List<TeamMember>>(
                    future: _memeber.getTeamMembersByLeader(1),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data!.isEmpty) {
                        return SizedBox(
                          height: fieldHeight,
                          child: const Loader(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      List<TeamMember> team = teamMembers;
                      ratings = List.generate(
                        team.length,
                        (index) => WorkerRating(
                            team[index].intId,
                            ratings.isEmpty
                                ? ratingIntial
                                : ratings[index].decRating),
                      );
                      return Row(
                        children: List.generate(
                          team.length,
                          (index) {
                            if (index == 0) {
                              return SizedBox();
                            }
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02),
                                child: team[index].blnIsLeader
                                    ? TeamMemberDisplay(
                                        height: screenHeight * 0.15,
                                        width: screenWidth * 0.4,
                                        name: team[index]
                                                .strName
                                                .contains('null null')
                                            ? "رئيس الشعبة"
                                            : team[index].strName,
                                        icon: Icons.flag_circle_rounded,
                                        color: AppColor.main,
                                      )
                                    : InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              backgroundColor:
                                                  AppColor.background,
                                              useRootNavigator: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(25.0),
                                                ),
                                              ),
                                              context: context,
                                              builder: (BuildContext context) {
                                                // Pass the selected TeamMember and the list of WorkerRating objects
                                                return ratingSheet(context,
                                                    team[index], index);
                                              });
                                        },
                                        child: TeamMemberAnalyticsDisplay(
                                          height: screenHeight * 0.15,
                                          width: screenWidth * 0.4,
                                          name: team[index].strName,
                                          icon: Icons.emoji_emotions_outlined,
                                          color: AppColor.secondary,
                                          rating: ratings[index].decRating,
                                        ),
                                      ));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
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
                print(
                  widget.TaskID,
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) => buildConfirmDialog(
                      context,
                      "تأكيد العمل",
                      "موقع العمل",
                      "ش.,صفي التل.عمان",
                      widget.TaskID,
                      commentController.text,
                      selectedMediaFiles,
                      ratings),
                );
              }),

              SizedBox(
                height: screenHeight * 0.05,
              ),
            ])),
      ),
    );
  }
}
