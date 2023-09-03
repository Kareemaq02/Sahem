
import 'dart:io';

import 'package:account/API/TaskAPI/submit_task_request.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/SubmitTask/pageView.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:account/Widgets/Popup/popup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';



List<MediaFile> selectedMediaFiles = [];
final List<String> imageList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
    'img2.png',
    'img3.png',
  ];

class FinishTask extends StatefulWidget {
  final String TaskID;

   const FinishTask({super.key, required this.TaskID, }) ;

  @override
  State<FinishTask> createState() => _ComaplintState();
}

class _ComaplintState extends State<FinishTask> {

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
    getImages(context);
    super.initState();
    print(selectedMediaFiles.length);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
     
      
    // });
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
            false,
          ),
        );
      });
    } else {
      Navigator.pop(context);
    }
  }









//remove , add icons



  @override
  Widget build(BuildContext context) {

   double screenWidth = MediaQuery.of(context).size.width;
   double screenHeight = MediaQuery.of(context).size.height;

    return  Scaffold(
      
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar:BottomNavBar1(3),
       appBar:myAppBar(context,"تسليم العمل ",false,135),
      body:
       SingleChildScrollView(
        scrollDirection: Axis.vertical,
         child: Column(
          children: [ 
          MyPageView(),
         
          //const SizedBox(height: 0,),
           Padding(
             padding:  EdgeInsets.all(screenWidth * 0.02),
             child: Container(
             height: screenHeight * 0.25,
             decoration: BoxDecoration(
               border:Border.all(color: AppColor.main,width: 0.5),
               borderRadius: BorderRadius.circular(10),
             ),
             child:  const Padding(
               padding: EdgeInsets.all(5.0),
               child:  TextField(
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
           SizedBox(height: screenHeight * 0.02,),
              BottonContainer("استمرار", Colors.white, AppColor.main,  screenWidth * 0.7,context,true,null,(){
               showDialog(
              context: context,
              builder: (BuildContext context) => 
              buildConfirmDialog(context,
              "تأكيد العمل",
              "موقع العمل",
              "ش.صوفي التل.عمان",
              widget.TaskID,
              commentController.text,
              selectedMediaFiles
              
              ),
            );}), 
  	       
            SizedBox(height: screenHeight * 0.05,),
        
          
          ],
             ),
       ),
        ) ;                   
     }

}





