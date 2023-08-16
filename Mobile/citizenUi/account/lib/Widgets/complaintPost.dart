
// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget post1(BuildContext context,  
{
required String dtmDateCreated,
required String strComplaintTypeEn,
required String strComment,
required int intVotersCount,
required String strStatus,
required String strUserName,
required var address,
required var intComplaintId,



}) {
  return
   Padding(
    padding: const EdgeInsets.only(top:50.0,right:10),
    child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 108, 107, 107),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                ),
              ],
            ),
          child:
    
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Card
       
  
        // Photo
        Stack(
         
          children: <Widget>[
             Container(
              height: 183.0,
         decoration: const BoxDecoration(
           color: Color(0xff6f407d),
           borderRadius: BorderRadius.only(
             topLeft: Radius.circular(10.0),
             topRight: Radius.circular(10.0),
           ),
         ),
              child: Image.asset('assets/icons/pothole.jpg',fit:BoxFit.fill,),
        ),
            // StatusBox
    MediaQuery(
    data: MediaQuery.of(context), child:
  
     Padding(
     padding: const EdgeInsets.all(8.0),
     child: Container(
      height: 15,
      width: 50,
        decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(10.0),
          ),
        child:
          //status
                  Text( 
                  strStatus,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Euclid Circular A',
                    fontSize: 12,
                    color: Color(0xff6f407d),
                  ),
                  softWrap: false,
                ),
                    ),
     ),
          ),],
        ),
        
  
        // Data
    const SizedBox(height: 10,),
        Row(
          children: [
            //username
             Text(
              strUserName,
              style:const  TextStyle(
                fontFamily: 'Euclid Circular A',
                fontSize: 13,
                color: Color(0xff6f407d),
                fontWeight: FontWeight.w700,
              ),
              softWrap: false,
            ),
          const Spacer(),
          
          ],
        ),
  
  
         // Description
               Padding(
                padding:const  EdgeInsets.only(left: 2.0, right: 41.7,bottom: 30),
                child: Text(
                '$strComplaintTypeEn\n${strComment=="" ? strComment : 'Uneven road surface due to pothole - hazardous conditions!'}',

                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Color(0xff000000),
                  ),
                ),
              ),
          const SizedBox(height: 1,),
  
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            // address
              Text(
                address,
                style: const TextStyle(
                  fontFamily: 'Euclid Circular A',
                  fontSize: 10,
                  color: Color(0xff92a5c6),
                  fontWeight: FontWeight.bold,
                ),
                softWrap: false,
              ),
                   
             const SizedBox(width: 18,),
                
              //    Align(
              //     alignment: Alignment.bottomRight,
              //     child: Text(
              //       dtmDateCreated.toString().substring(0,10),
              //       style: const TextStyle(
              //         fontFamily: 'Euclid Circular A',
              //         fontSize: 10,
              //         color: Color(0xff92a5c6),
              //         fontWeight: FontWeight.bold,
              //       ),
              //       softWrap: false,
              //     ),),
              // const SizedBox(width: 40,),
              //   //time
              //    Align(
              //           alignment: Alignment.bottomRight,
              //           child: Text(
              //              dtmDateCreated.toString().substring(11,17),
              //             style:const   TextStyle(
              //               fontFamily: 'Euclid Circular A',
              //               fontSize: 10,
              //               color: Color(0xff92a5c6),
              //                fontWeight: FontWeight.bold,
              //             ),
              //             softWrap: false,
              //           ),
              //         ),
            
                   ],),
          )
             
      ],
    ),
    ),
  );
}