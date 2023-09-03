
import 'package:account/Repository/color.dart';
import 'package:account/Screens/SubmitTask/submitTask.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:flutter/material.dart';


class confirm extends StatefulWidget {




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
        SizedBox(height: 200,),
        BottonContainer("الرجوع", Colors.white, AppColor.main,230,context,false,FinishTask(TaskID: '',),(){})
      ]
      ), 
    ));
  }
}

