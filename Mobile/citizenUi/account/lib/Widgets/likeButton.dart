// ignore_for_file: unused_local_variable, file_names, prefer_const_constructors

import 'package:account/API/vote_complaint.dart';
import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart' ;
  

// Widget vote(count,comlaintID){
//   return 
//   LikeButton(
//     likeBuilder: (isLiked) {
       
//       return Icon(
//         Icons.arrow_upward_rounded,
//         size: 26,
//         color: isLiked? AppColor.main:Colors.grey,

//       );
//     },
//     likeCount:count,
//     countBuilder: (int? count,bool isLiked,String text){
//       var color=isLiked ? AppColor.main:Colors.grey;
//       Widget result;
//       if(count==0){
//         result=Text("Vote",);
//       }
//       return null;
      
//     },
//    onTap: (isLiked) async {
//       if (!isLiked) {
//         VoteComplaint a = VoteComplaint();
       
//          await a.sendVoteRequest(comlaintID);
       
//       }
//       return !isLiked;
//     },
        
    
   
//     );
  
      
// }




// Widget unVote(count,comlaintID){
//   return 
//   LikeButton(
//     likeBuilder: (isLiked) {
       
//       return Icon(
//         Icons.arrow_downward_rounded,
//         size: 26,
//         color: isLiked? AppColor.main:Colors.grey,

//       );
//     },
//     likeCount:count,
//     countBuilder: (int? count,bool isLiked,String text){
//       var color=isLiked ? AppColor.main:Colors.grey;
//       Widget result;
//       if(count==0){
//         result=Text("Vote",);
//       }
//       return null;
      
//     },
//    onTap: (isLiked) async {
//       if (!isLiked) {
//         VoteComplaint a = VoteComplaint();
       
//          await a.sendVoteRequest(comlaintID);
       
//       }
//       return !isLiked;
//     },
        
    
   
//     );
  
      
// }





Widget vote(count,comlaintID){
  return 
  LikeButton(
    likeBuilder: (isLiked) {
       return 
       isLiked? Image.asset("assets/icons/upActive.png",scale: 1.1,) :
       Image.asset("assets/icons/upInactive.png",scale: 1.1,) ;
    },
   onTap: (isLiked) async {
      if (!isLiked) {
        VoteComplaint a = VoteComplaint();
         await a.sendVoteRequest(comlaintID);
      }
      return !isLiked;
    },
       
    );
    
}

Widget countVotes(count) {
  return Expanded(
    child: Stack(
      children: [
        Center(
          child: Column(
            children: [
              Text(count.toString(),style: TextStyle(color: AppColor.secondary),),
              //SizedBox(width:10,height: 1,), // Adding a little padding between text and line
              Divider(thickness: 1, color: Color(0xFFC9BD40),height: 5,),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget downVote(count,comlaintID){
  return 
  LikeButton(
    likeBuilder: (isLiked) {
       return 
       isLiked? Image.asset("assets/icons/downActive.png",scale: 1.1,) :
       Image.asset("assets/icons/downInactive.png",scale: 1.1,) ;
  
    },
    

   onTap: (isLiked) async {
      if (!isLiked) {
        VoteComplaint a = VoteComplaint();
       
         await a.sendVoteRequest(comlaintID);
       
      }
      return !isLiked;
    },
   
    );
      
}






