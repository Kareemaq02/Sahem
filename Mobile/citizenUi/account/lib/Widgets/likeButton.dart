// ignore_for_file: unused_local_variable, file_names, prefer_const_constructors

import 'package:account/API/vote_complaint.dart';
import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart' ;
  

Widget vote(count,comlaintID){
  return 
  LikeButton(
    likeBuilder: (isLiked) {
       
      return Icon(
        Icons.arrow_upward_rounded,
        size: 20,
        color: isLiked? AppColor.main:Colors.grey,

      );
    },
    likeCount:count,
    countBuilder: (int? count,bool isLiked,String text){
      var color=isLiked ? AppColor.main:Colors.grey;
      Widget result;
      if(count==0){
        result=Text("Vote",);
      }
      return null;
      
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




Widget unVote(count,comlaintID){
  return 
  LikeButton(
    likeBuilder: (isLiked) {
       
      return Icon(
        Icons.arrow_downward_rounded,
        size: 20,
        color: isLiked? AppColor.main:Colors.grey,

      );
    },
    likeCount:count,
    countBuilder: (int? count,bool isLiked,String text){
      var color=isLiked ? AppColor.main:Colors.grey;
      Widget result;
      if(count==0){
        result=Text("Vote",);
      }
      return null;
      
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

