import 'dart:io';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_indicator/page_indicator.dart';
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
    super.initState();
    controller = PageController();
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
        duration: const Duration(milliseconds: 500), // Adjust the duration as needed.
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
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      selectedMediaFiles.add(
        MediaFile(
          File(pickedFile.path),
          31.958946, // Placeholder value for decLat
          31.958946, // Placeholder value for decLng
          false,
        ),
      );
      setState(() {});
      print(selectedMediaFiles.length);
    } else {
      Navigator.pop(context);
    }
  }

  Widget stackButton(IconData icon, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                    child: Image.file(
                      selectedMediaFiles[position].file,
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