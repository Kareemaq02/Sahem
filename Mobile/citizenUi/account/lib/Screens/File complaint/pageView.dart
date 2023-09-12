import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:account/Repository/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Screens/Home/publicFeed.dart';
import 'package:account/API/file_complaint_request.dart';


  final _picker = ImagePicker();
  List<MediaFile> selectedMediaFiles = [];

class MyPageView extends StatefulWidget {
  @override
  _PageViewState createState() => _PageViewState();
}

class _PageViewState extends State<MyPageView> {
   PageController? controller;


  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
    controller = PageController();
    
  }

  late var address;
  bool _isDisposed = false;
  double lat = 0.0;
  double lng = 0.0;

  @override
  void dispose() {
    late var address;
    _isDisposed = true;
    super.dispose();
  }

  String? _currentAddress;

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

  void removeImage(int index, BuildContext context) {
    if (index >= 0 &&
        index < selectedMediaFiles.length &&
        selectedMediaFiles.length != 1) {
      
      setState(() {
        selectedMediaFiles.removeAt(index);
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
        const SnackBar(content: Text('يجب ان يحتوي البلاغ على صورة واحدة عالاقل')),
      );
    }
  }

  Future<void> getImages(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      selectedMediaFiles.add(
        MediaFile(
          File(pickedFile.path),
          currentPosition!.latitude,
          currentPosition!.longitude, 
          false,
        ),
       
      );

      setState(() {});
      print(selectedMediaFiles.length);
      print(selectedMediaFiles.first);
      print(
        currentPosition!.longitude,
      );
    } else {
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
                    child: selectedMediaFiles[position].decLat == null ||
                            selectedMediaFiles[position].decLng == null
                        ? CircularProgressIndicator.adaptive()
                        : Image.file(
                            selectedMediaFiles[position].file!,
                            fit: BoxFit.cover,
                            scale: 0.1,
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      stackButton(Icons.add, () {
                        addImage(context);
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
    );
  }

  void addImage(BuildContext context) {
    if (selectedMediaFiles.length <= 2) {
      getImages(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تجاوزت الحد الأقصىلالتقاط الصور')),
      );
    }
  }
}