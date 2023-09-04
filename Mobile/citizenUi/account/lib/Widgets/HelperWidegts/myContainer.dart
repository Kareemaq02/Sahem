import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';

Widget  Mycontainer(double height,Widget){

  return 
   Container(
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
  child:
   Container(
                height: height,
                
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
                
                  child: 
                Widget ,
                )));
}