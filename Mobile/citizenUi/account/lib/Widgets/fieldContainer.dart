
import 'package:account/Repository/color.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';

Widget FieldContainer(String fieldName,bool isVisible,fieldIcon,inputController)
{
  return   Container(
              height:49 ,
              width: 240,
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
                  hintStyle: const TextStyle(color:AppColor.main,fontSize:12.5,fontFamily:ArabicFont.elMessiri),
                  hintText:fieldName,
                  suffixIcon: Icon(fieldIcon,color:AppColor.main,size: 20,),
                  border: InputBorder.none,
                 ),
                 
            )
  );


  
}