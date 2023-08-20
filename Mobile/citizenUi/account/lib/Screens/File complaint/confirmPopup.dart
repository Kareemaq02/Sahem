





import 'package:account/Repository/color.dart';
import 'package:account/Widgets/bottonContainer.dart';
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
          //fontFamily: AutofillHints.addressCityAndState,
          fontSize:13, 
        ),
        textDirection: TextDirection.rtl,
        ),
    
      //value
    
     
    ],),
  );
}


//confirm complaint
Widget buildConfirmDialog(BuildContext context) {
  return  AlertDialog(
    title: const Text('تأكيد البلاغ؟ ',textAlign: TextAlign.center,),
    content:  SizedBox(  
    height: 125,
    child:
         Column(children: [
            RowInfo( "نوع البلاغ", "مخلفات اعمال بناء"),
            RowInfo( "موقع البلاغ", "مخلفات اعمال بناء"),
           const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  BottonContainer("الغاء", AppColor.main, Colors.white,100,context,true,null,(){}),
                  const SizedBox(width: 10,),
                 BottonContainer("استمرار", Colors.white, AppColor.main, 100,context,false,null,(){}),
                ],
              ),
            ),
          ],) 
      
    ),
    
  
  );
}
