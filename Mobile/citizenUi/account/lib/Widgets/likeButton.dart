// ignore_for_file: unused_local_variable, file_names, prefer_const_constructors

import 'package:account/API/vote_complaint.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart' ;
  

Widget like(count,comlaintID){
  return 
  LikeButton(
    likeBuilder: (isLiked) {
       
      return Icon(
        Icons.volunteer_activism_rounded,
        size: 30,
        color: isLiked? Colors.purple:Colors.grey,
        
      );
    },
    likeCount:count,
    countBuilder: (int? count,bool isLiked,String text){
      var color=isLiked ? Colors.purple:Colors.grey;
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
      else{
        VoteComplaint a = VoteComplaint();
         await a.RemoveVoteRequest(comlaintID);
      
      }
      return !isLiked;
    },
        
    
   
    );
  
      
}

