import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';


Widget DataBox(String label,widget,data){

  return Padding(
    padding: const EdgeInsets.only(top: 6.0),
    child: Container(
      width: double.infinity,
      height:70,
      decoration: const BoxDecoration(
        color: Colors.white70,
        //border: Border(bottom: BorderSide(color: AppColor.main,width: 6,),),
       //borderRadius: BorderRadiusDirectional.circular(20),
      ),

      child:Column(
        //mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
         Padding(
           padding: const EdgeInsets.only(right:8.0,top:8.0),
           child: Text(
            label,
           textAlign: TextAlign.end,
           textDirection: TextDirection.rtl,
            style: const TextStyle(
            color: AppColor.main,
            fontSize: 10,
            fontWeight: FontWeight.w100,
            fontFamily:'DroidArabicKufi',
            ),
                 ),
         ),
    
        Expanded(
          child: Row(
            children: [
             widget(),
              const Spacer(),
               Padding(
                padding: EdgeInsets.only(right:12.0),
                child: Text(
                  data ,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                  color: AppColor.secondary,
                  fontSize: 12,
                  fontFamily:'DroidArabicKufi',
                  
                  ),
                ),
              ),
            ],
          ),
        ),
    
      ]),
    ),
  );
}


Widget InfoBox(name){

  return Material(
  
     shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),),
  
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
         color: Colors.white70,
        border: Border(bottom: BorderSide(color: AppColor.main,width: 6,),),
       //borderRadius: BorderRadiusDirectional.circular(20),
      ),
    
    
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
         name,
          textAlign: TextAlign.center,
          style: TextStyle(
          color: AppColor.main,
          fontSize: 20,
          fontFamily:'DroidArabicKufi',
          ),
        ),
    
        Text(
          'الرقم الوطني: 20201501023',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: TextStyle(
          color: AppColor.secondary,
          fontSize: 15,
          ),
        ),
    
      ]),
    ),
  
  );
}







