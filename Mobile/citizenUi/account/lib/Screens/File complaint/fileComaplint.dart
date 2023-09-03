
// ignore_for_file: use_build_context_synchronously


import 'dart:io';

import 'package:account/API/file_complaint_request.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/File%20complaint/dropdown.dart';
import 'package:account/Screens/File%20complaint/pageView.dart';
import 'package:account/Widgets/appBar.dart';
import 'package:account/Widgets/bottomNavBar.dart';
import 'package:account/Widgets/bottonContainer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Screens/File complaint/confirmPopup.dart';



class FileCompalint extends StatefulWidget {

   const FileCompalint({super.key}) ;
   

  @override
  State<FileCompalint> createState() => ComaplintState();
}

class ComaplintState extends State<FileCompalint> {

  late PageController controller;
  GlobalKey<PageContainerState> key = GlobalKey();
 TextEditingController commentController = TextEditingController();


@override
void dispose() {

  selectedMediaFiles.clear();
  super.dispose();
}

 


@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    getImages(context);
  });
}

Future<void> getImages(BuildContext context) async {
     final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        selectedMediaFiles.add(
          MediaFile(
            File(pickedFile.path),
            31.958946, // Placeholder value for decLat
            31.958946, // Placeholder value for decLng
            false,
          ),
        );
      });
    } else {
      Navigator.pop(context);
    }
  }






  @override
  Widget build(BuildContext context) {
   
    return  Scaffold(
       backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton:const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:BottomNavBar1(3),
       appBar:myAppBar(context,"ارسال بلاغ",false,170),
      body:
       SingleChildScrollView(
        scrollDirection: Axis.vertical,
         child: Column(
          children: [ 
          MyPageView(),
          const MyDropDown(),
          const SizedBox(height: 0,),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
             height: 150,
             decoration: BoxDecoration(
               border:Border.all(color: AppColor.main,width: 1),
               borderRadius: BorderRadius.circular(10),
             ),
             child: const Padding(
               padding: EdgeInsets.all(10.0),
               child: TextField(
                 maxLines: null, 
                 decoration: InputDecoration(
                   hintText: 'أضف تعليق ..',
                   border: InputBorder.none,
                   hintTextDirection: TextDirection.rtl,
                   hintStyle: TextStyle(color: AppColor.main),
                 ),
                 
               ),
             )),
           ),
           const SizedBox(height: 10,), 
            BottonContainer("استمرار", Colors.white, AppColor.main, 250,context,true,null,(){
               showDialog(
              context: context,
              builder: (BuildContext context) => buildConfirmDialog(context,dropdown.stringName,"ش.وصفي التل.عمان",commentController.text),
            );}), 
            const SizedBox(height: 50,),
        
          
          ],
             ),
       ),
        ) ;                   
     }

}

