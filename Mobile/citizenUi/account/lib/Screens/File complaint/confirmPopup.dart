





// ignore_for_file: file_names, non_constant_identifier_names

import 'package:account/API/file_complaint_request.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/File%20complaint/dropdown.dart';
import 'package:account/Screens/File%20complaint/pageView.dart';
import 'package:account/Widgets/popupBotton.dart';
import 'package:flutter/material.dart';

Complaint fileObj=Complaint();

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


//confirm complaint
Widget buildConfirmDialog(BuildContext context,type,address,comment) {
  return  AlertDialog(
    title: const Text('تأكيد البلاغ؟ ',textAlign: TextAlign.center,style: TextStyle(fontFamily:'DroidArabicKufi'),),
    content:  Container(  
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(60)),
    height: 135,
    child:
         Column(children: [
            RowInfo( "نوع البلاغ", type),
            RowInfo( "موقع البلاغ", address),
           const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
              
                  BottonContainerPopup("الغاء", AppColor.main, Colors.white,context,true,null,(){Navigator.of(context).pop();}),
                   const SizedBox(width: 3,),
                   BottonContainerPopup("استمرار", Colors.white, AppColor.main,context,true,null,(){fileObj.fileComplaint(context,dropdown.intID, 1, selectedMediaFiles, comment);}),
                ],
              ),
            ),
          ],) 
      
    ),
    
  
  );
}

Widget PopupButton(context){

  return    SizedBox(
              height:35 ,
              width: 100,
              child: ElevatedButton(
               style: ButtonStyle(
               padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), 
              backgroundColor: MaterialStateProperty.all<Color>(AppColor.main),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), 
               side: const BorderSide(
                    color:AppColor.main,
                    width: 1,
                    //style: BorderStyle.solid,
                  ),
                ),
                ),
              ),
                        
                onPressed:() {
                 // selectedTypes.clear(); 
                 // selectedStatus.clear(); 
                Navigator.of(context).pop();
              // getFilteredComplaints(selectedTypes,selectedStatus);
              }, child: const Text("استمرار")),
            );
}


