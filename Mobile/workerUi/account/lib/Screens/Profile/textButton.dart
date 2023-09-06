import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';


Widget textButtn(){
  return
   TextButton(onPressed:() { }, 
  child: 
  const Text(
    'تغير',
  style: TextStyle(
   color: AppColor.main,
   fontSize: 10,
   fontWeight: FontWeight.bold,
   fontFamily:'DroidArabicKufi',
   ),));
}