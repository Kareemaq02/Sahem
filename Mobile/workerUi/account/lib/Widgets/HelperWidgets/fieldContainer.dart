
import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';

Widget FieldContainer(context,String fieldName,bool isVisible,fieldIcon,inputController)
{
  final double screenWidth = MediaQuery.of(context).size.width;
  final double containerWidth = screenWidth * 0.75; 
  final double containerHeight = 45;

  return   Container(
              height:containerHeight ,
              width: containerWidth,
              decoration:
               BoxDecoration(
                borderRadius:const BorderRadius.all(Radius.circular(50)),
              border:Border.all(
              color:AppColor.main,
              width: 1,
              style: BorderStyle.solid
              ),
       ),    
              child: 
              TextFormField(
                controller: inputController,
                
                obscureText: isVisible,
                textDirection: TextDirection.rtl,
                decoration: 
                 InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: const TextStyle(color:AppColor.main,fontSize:11, fontFamily:'DroidArabicKufi', ),
                  hintText:fieldName,
                  suffixIcon: Icon(fieldIcon,color:AppColor.main,size: 20,),
                  border: InputBorder.none,
                 ),
                 
            )
  );


  
}