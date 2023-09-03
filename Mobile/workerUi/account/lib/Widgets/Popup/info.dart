
import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';


Widget RowInfo(title,value){
  return
  Padding(
    padding: const EdgeInsets.all(2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      //title
       Text(
        value,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          color: AppColor.secondary,
          //fontFamily: AutofillHints.addressCityAndState,
          fontSize:13, 
        ),
        ),
      Text(
        title,
        style: const TextStyle(
          color: AppColor.main,
          fontFamily: 'DroidArabicKufi',
          fontSize:13, 
        ),
        textDirection: TextDirection.rtl,
        ),
    
      //value
    
     
    ],),
  );
}
