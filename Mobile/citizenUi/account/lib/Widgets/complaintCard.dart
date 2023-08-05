import 'package:account/Repository/color.dart';
import 'package:account/Widgets/likeButton.dart';
import 'package:account/Widgets/text.dart';
import 'package:flutter/material.dart';

Widget ComplaintCard(BuildContext context,  
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
    padding: const EdgeInsets.only(top:20.0),
    child: Container(
      width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(1.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 108, 107, 107),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                ),
              ],
            ),
          child:
    
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
       
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // Card
        Row(children: [
    
         Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 20,
           width: 65,
           decoration: BoxDecoration(
           color: const Color(0xffffffff),
           borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 213, 211, 211),
                    offset: Offset(0, 0),
                    blurRadius: 5,
                  ),
                ],
              
           ),
            child:
            Row(
                mainAxisSize: MainAxisSize.max,
                 children: [
                      text(
                   "موافق عليه",
                    AppColor.secondary,
                 ),
                 Icon(Icons.circle,color: AppColor.secondary,size: 12,),
               
                 ],
                 ),
                 ),
                    ),
            Spacer(),
            Text( 
                strUserName,
                textDirection: TextDirection.rtl,
                style:const  TextStyle(
                  fontFamily: 'Euclid Circular A',
                  fontSize: 13,
                  color:AppColor.secondary,
                  fontWeight: FontWeight.w700,
                ),
                softWrap: false,
              ),
        ],) ,  
    
        //time 
        Text('قبل 5 ساعات',style:TextStyle(color: AppColor.secondary,fontSize: 11)),
        SizedBox(height: 10,), 
        //description 
    
              Text(
                 '${strComment=="" ? strComment : 'يرجى العمل على حل النشكلة بأسرع وقت ممكن, مع ضرورة التصويت لحل هذا الممشكلة'}',
                  textDirection: TextDirection.rtl,
                   style: const TextStyle(
                     fontFamily: 'Poppins',
                     fontWeight: FontWeight.w300,
                     fontSize: 12,
                     color:AppColor.secondary,
                   ),
                 ),
      
          // Photo
          Container(
           height: 173.0,
           decoration:  BoxDecoration(
           
             borderRadius:const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
             ),
           ),
           child: Image.asset('assets/icons/pothole.jpg',fit:BoxFit.cover,),
          ),
          
        Divider(),
            Row(children: [
            // address
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                   
                    children: [
                      Text(
                        address,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontFamily: 'Euclid Circular A',
                          fontSize: 13,
                          color: Color(0xff92a5c6),
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: false,
                      ),
                      Icon(Icons.location_on_sharp,color:Colors.grey,size: 15,)
                    ],
                  ),
                ),
                   
             //const SizedBox(width:,),
             Spacer(),
             vote(intVotersCount,intComplaintId),
             unVote(intVotersCount,intComplaintId),
            // IconButton(onPressed:() {}, icon: Icon(Icons.thumb_up_alt,)),
             
              //   // date
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
            
                    ],
      ),
    ),
    ),
  );
}