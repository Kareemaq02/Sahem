import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: file_names



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