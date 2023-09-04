import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/VoteWidegts/count.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/API/watch_complaint_request.dart';
import 'package:account/Widgets/VoteWidegts/downVote.dart';
import 'package:account/Widgets/VoteWidegts/voteButton.dart';



WatchComplaint watchReq=WatchComplaint();

Widget ComplaintCard(BuildContext context,  
{
required String dtmDateCreated,
required String strComplaintTypeEn,
required String strComment,
required int intVotersCount,
required String strStatus,
required String strUserName1,
required String strUserName2,
required var address,
required int intComplaintId,
required int isVoted,
required bool? isWatched,
//required var  image,




})
 {
  return
   Padding(
     padding: const EdgeInsets.only( top:8.0,bottom:8.0),
     child: Container(
       width: double.infinity,
       height: 470,
             decoration: BoxDecoration(
               color: const Color(0xffffffff),
               borderRadius: BorderRadius.circular(0.0),
               boxShadow: const [
                 BoxShadow(
                   color: Color.fromARGB(255, 255, 241, 241),
                   offset: Offset(0, 0),
                   blurRadius: 5,
                 ),
               ],
             ),
           child:
     
     Padding(
       padding: const EdgeInsets.all(8.0),
       child: Column(
        
         //mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.end,
         children: <Widget>[
           // Card
         Row(children: [
         //status container    
         Container(
          
         height: 20,
         
         // width: 67,
         decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
          BoxShadow(
          color: Color.fromARGB(255, 223, 222, 222),
          offset: Offset(0, 0),
          blurRadius: 2,
          spreadRadius: 0.5,
         ),
            ],
          ),
          child: Row(
         mainAxisSize: MainAxisSize.max,
         children: [
          text(
          "موافق عليه",
          AppColor.secondary,
          ),
          const Icon(Icons.circle, color: AppColor.secondary, size: 10),
         ],
          ),
         ),
             const Spacer(),
             Column(
               children: [
                 Text( 
                     strUserName1+strUserName2,
                     textDirection: TextDirection.rtl,
                     style:const  TextStyle(
                       fontFamily: 'Euclid Circular A',
                       fontSize: 13,
                       color:AppColor.textTitle,
                       fontWeight: FontWeight.w700,
                     ),
                     softWrap: false,
                   ),
               ],
             ),
        
         ],) ,  
                    //time 
        
         Text('قبل 5 ساعات',style:TextStyle( color: Color(0xff92a5c6),fontSize: 11)),
       
        
         //description    
               Expanded(
                flex: 1,
                 child: ReadMoreText(
                  strComment!="" ? strComment : 
                  "أرجو من الجهات المختصة النظر في وضع الشوارع وإصلاح الحفر بأسرع وقت ممكن، حيث أن وجود هذه الحفر يشكل خطراً على المركبات والمارة. نأمل توفير السلامة والراحة للجميع والعمل على تحسين حالة الطرق في المنطقة. شكراً لتفهمكم وتعاونكم.",
                  trimLines: 2,
                  colorClickableText: Colors.grey,
                  textDirection: TextDirection.rtl,
                 trimMode: TrimMode.Line,
                 trimCollapsedText: 'اقرأ المزيد',
                 trimExpandedText: 'الرجوع',
                 moreStyle: const 
                 TextStyle( fontFamily:'DroidArabicKufi',
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color: Colors.grey,),
                         style:  TextStyle(
                        fontFamily:'DroidArabicKufi',
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color:AppColor.textBlue
                      ),
                    
                             
                 ),
               ),
       
         // Photo
           SizedBox(height: 10,),
           Container(
            height: 300.0,
       
            child: Image.asset('assets/icons/pothole.jpg',fit:BoxFit.cover,),
           ),
       
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
               
             // address
               Text(
                 address,
                 textDirection: TextDirection.rtl,
                 style: const TextStyle(
                   fontFamily:'DroidArabicKufi',
                   fontSize: 10,
                   color: AppColor.secondary,
                   fontWeight: FontWeight.bold,
                 ),
                 softWrap: false,
               ),
                    
              //const SizedBox(width:,),
              const Spacer(),
              VoteWidget(initialCount: intVotersCount,complaintID:intComplaintId, isVoted:isVoted),
               CountWidget(initialCount:intVotersCount),
               DownWidget(initialCount: intVotersCount,complaintID:intComplaintId, isVoted:isVoted),
              Container( width: 1, color: Colors.grey,height: 25, ),
              IconButton(onPressed: (){watchReq.watchRequest(intComplaintId);}, 
              icon: Icon(Icons.bookmark_outline_sharp,size: 29,
              color:isWatched! ? AppColor.main 
              :Colors.grey,),)
              
             
                    ],),
             
                     ],
       ),
     ),
     ),
   );
}