import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';


Widget DataBox(String label,widget,data){

  return Padding(
    padding: const EdgeInsets.only(top: 5.0),
    child: Container(
      width: double.infinity,
      height:60,
      decoration: const BoxDecoration(
        color: Colors.white,
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
                padding: const EdgeInsets.only(right:12.0),
                child: Text(
                  data ,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
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

  return Container(
    width: double.infinity,
    height: 80,
    decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 1.5,
        offset: Offset(0, 3),
      ),
    ],
  ),
  
    child: Container(
      //height: height,
                
               decoration:  BoxDecoration(
                
                color: Colors.white,
               
               // border: Border.all(color: Colors.black,width:.5),
                // border: Border(bottom: BorderSide(width: 3.5, color:AppColor.main,),
                // top: BorderSide(width:0.5,color: Colors.black ),
                // left: BorderSide(width:0.5,color: Colors.black ),
                // right: BorderSide(width:0.5,color: Colors.black ),
                // ),
                 border: Border.all(color: Colors.black,width:.2),
               borderRadius: BorderRadius.all(Radius.circular(10)),
             
                ),
                child:Container(
                decoration: BoxDecoration(
               // border: Border.all(color: Colors.black,width:.5),
                border: Border(bottom: BorderSide(width: 2.5, color:AppColor.main,),
              
                ),),
                
                  
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
         'ربى أبورمان',
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
          fontSize: 11,
          fontFamily:'DroidArabicKufi',
          ),
        ),
      
      ]),
    ),
  ));
}







