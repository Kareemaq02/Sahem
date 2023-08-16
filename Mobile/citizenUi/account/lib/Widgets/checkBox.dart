

import 'package:account/Repository/color.dart';
import 'package:account/Widgets/text.dart';
import 'package:flutter/material.dart';


 bool isChecked = false;
 
Widget checkboxWidget(String option,context){
  return GestureDetector(
    onTap: () => isChecked=false,
    child: Row(
      children: [
         text(option,AppColor.main),
         SizedBox(width: MediaQuery.of(context).padding.left + 2,),
        Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  // color: Colors.white,
                 borderRadius:const BorderRadius.all(Radius.circular(4)),
                 border: Border.all(color: AppColor.main),
               //  color: isChecked ? AppColor.main : Colors.white10,
                ),
               
  ),
    
      ],
    ));
}