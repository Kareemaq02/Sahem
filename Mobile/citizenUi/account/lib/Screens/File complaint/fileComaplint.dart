import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:account/Repository/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Screens/Home/publicFeed.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/API/file_complaint_request.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:account/Screens/File%20complaint/dropdown.dart';
import 'package:account/Screens/File%20complaint/pageView.dart';
import 'package:account/Widgets/HelperWidegts/complaintCard.dart';
import 'package:account/Screens/File complaint/confirmPopup.dart';

// ignore_for_file: use_build_context_synchronously
GlobalKey<PageContainerState> keyGlobal = GlobalKey();
class FileCompalint extends StatefulWidget {
  const FileCompalint({super.key});

  @override
  State<FileCompalint> createState() => ComaplintState();
}

class ComaplintState extends State<FileCompalint> {
  late PageController controller;

  TextEditingController commentController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  bool _permissionRequested = false;

  @override
  void dispose() {
    selectedMediaFiles.clear();
    super.dispose();
  }

  @override
  void initState() {
    getImages(context);
    //_getCurrentPosition();
    
    fetchAddress();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
   
    });
  }

  String address = "";
Future<void> fetchAddress() async {
    if (currentPosition != null) {
      address = (await getAddressFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude))!;

      if (mounted) {
        setState(() {});
        print(address);
      }
    }
  }

  bool _isDisposed = false;
  double lat = 0.0;
  double lng = 0.0;


  Future<bool> _handleLocationPermission() async {
    // if (_permissionRequested) {
    //   return false;
    // }

    bool serviceEnabled;
    LocationPermission permission;
    _permissionRequested = true;

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

 Future<void> getImages(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

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

      await _getCurrentPosition(); // Wait for latitude and longitude

      setState(() {
        final mediaFile = selectedMediaFiles.last;
        mediaFile.decLat = currentPosition!.latitude;
        mediaFile.decLng = currentPosition!.longitude;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: keyGlobal,
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavBar1(3),
        appBar: myAppBar(context, "ارسال بلاغ", false, screenSize.width * 0.5),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              MyPageView(),
              const MyDropDown(),
              Container(
                width: screenSize.width * 0.95,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.main, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: screenSize.height * 0.2,
                  child: TextField(
                    focusNode: textFieldFocusNode,
                    autofocus: true,
                    maxLines: null,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20.0, bottom: 50),
                      hintText: 'أضف تعليق ..',
                      border: InputBorder.none,
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(color: AppColor.main),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0), // Add spacing

              BottonContainer(
                "استمرار",
                Colors.white,
                AppColor.main,
                screenSize.width * 0.5,
                context,
                true,
                null,
                () async {
                  FocusScope.of(context).unfocus();

                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => buildConfirmDialog(
                        context,
                        dropdown.stringName,
                        address,
                        commentController.text),
                  );
                },
              ),
              //const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}
