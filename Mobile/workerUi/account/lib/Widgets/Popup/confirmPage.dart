import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/SubmitTask/submitTask.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
// ignore_for_file: library_private_types_in_public_api

// ignore_for_file: camel_case_types


// ignore_for_file: file_names



class confirm extends StatefulWidget {
  const confirm({super.key});





  @override
  _MconfirmState createState() => _MconfirmState();
}

class _MconfirmState extends State<confirm> {
 

  @override
  Widget build(BuildContext context) {
   
    return  Scaffold(
      backgroundColor: AppColor.background,
      body:  Center(
       
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        
        Image.asset("assets/icons/Frame 3.png",scale: 1.2,),
        const SizedBox(height: 200,),
        BottonContainer("الرجوع", Colors.white, AppColor.main,230,context,false,const FinishTask(TaskID: '',),(){})
      ]
      ), 
    ));
  }
}

