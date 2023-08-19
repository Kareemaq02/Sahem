


import 'package:account/Repository/color.dart';
import 'package:account/Widgets/text.dart';
import 'package:flutter/material.dart';

Widget logoutBox(){

  return Container(
    height:60,
    width: double.infinity,
    color: Colors.white,
    child: Row(
      children:[
      const Icon(Icons.logout_outlined,color:AppColor.secondary,),
       text("تسجيل الخروج",AppColor.secondary),
      ]),
    
  );
}