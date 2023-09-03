import 'dart:io';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Screens/SubmitTask/submitTask.dart';
import 'package:account/API/TaskAPI/submit_task_request.dart';

final _picker = ImagePicker();
//List<MediaFile> selectedMediaFiles = [];

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

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
        duration:
            const Duration(milliseconds: 500), 
        curve: Curves.easeInOut,
      );
    }
    if (selectedMediaFiles.length<=1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يجب ان يحتوي البلاغ على صورة واحدة عالاقل')),
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

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
       decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: 350,
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0,bottom: 15),
        child: SizedBox(
         
          child: PageIndicatorContainer(
            align: IndicatorAlign.bottom,
            length: selectedMediaFiles.length,
            indicatorSpace: 10.0,
            padding: const EdgeInsets.all(25),
            indicatorColor: Colors.grey,
            indicatorSelectorColor: Colors.blue,
            shape: IndicatorShape.circle(size: 7),
            child: PageView.builder(
              controller: controller,
              itemCount: selectedMediaFiles.length,
              itemBuilder: (context, position) {
                return Stack(
                  children: [
                    Container(
                      child: Center(
                        child: AspectRatio(
                           aspectRatio: 1/ 1,
                          child: Image.file(
                            scale: 0.1,
                            selectedMediaFiles[position].file,
                            fit: BoxFit.fitHeight,
                           // scale: 0.1,
                          ),
                        ),
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
