




import 'package:account/Repository/color.dart';
import 'package:account/Screens/Home/public_feed.dart';
import 'package:account/Widgets/bottonContainer.dart';
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
        
        Image.asset("assets/icons/Frame 5.png",scale: 1.2,),
        SizedBox(height: 200,),
        BottonContainer("الرجوع", Colors.white, AppColor.main,230,context,false,XDPublicFeed1(),(){})
      ]
      ), 
    ));
  }
}

