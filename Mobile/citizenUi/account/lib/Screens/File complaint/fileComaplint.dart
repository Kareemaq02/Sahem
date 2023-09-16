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
import 'package:account/Widgets/HelperWidegts/complaintCard.dart';
import 'package:account/Screens/File%20complaint/confirmPopup.dart';
// ignore_for_file: file_names, empty_catches


// ignore_for_file: use_build_context_synchronously
final picker = ImagePicker();
List<MediaFile> selectedMediaFiles = [];

class FileCompalint extends StatefulWidget {
  const FileCompalint({super.key});

  @override
  State<FileCompalint> createState() => ComaplintState();
}

class ComaplintState extends State<FileCompalint> {
  late PageController controller;

  TextEditingController commentController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

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

  bool _isDisposed = false;
  double lat = 0.0;
  double lng = 0.0;

  Future<bool> _handleLocationPermission() async {
    // if (_permissionRequested) {
    //   return false;
    // }

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

      await _getCurrentPosition(); // Wait for latitude and longitude
      if (_isDisposed) return;
      setState(() {
        final mediaFile = selectedMediaFiles.last;
        mediaFile.decLat = currentPosition!.latitude;
        mediaFile.decLng = currentPosition!.longitude;
        print(selectedMediaFiles.last);
        print(mediaFile.decLat);
        print(mediaFile.decLng);
      });
    } else {
      // Navigator.pop(context);
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
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavBar1(0),
        appBar: myAppBar(context, "ارسال بلاغ", false, screenSize.width * 0.5),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //const MyPageView(),
              //-------pageView---------//
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: SizedBox(
                  height: 210,
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
              ),

              const MyDropDown(),
              Container(
                width: screenSize.width * 0.95,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.main, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: screenSize.height * 0.2,
                  child: TextField(
                    controller: commentController,
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
                  final newAddress = await fetchAddress();
                  _showConfirmDialog(
                    context,
                    dropdown.stringName,
                    newAddress ?? '',
                    commentController.text,
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
      controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    if (selectedMediaFiles.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يجب ان يحتوي البلاغ على صورة واحدة عالاقل')),
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
}

Future<void> _showConfirmDialog(
    BuildContext context, String type, String address, String comment) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) => buildConfirmDialog(
      context,
      type,
      address,
      comment,
    ),
  );
}
