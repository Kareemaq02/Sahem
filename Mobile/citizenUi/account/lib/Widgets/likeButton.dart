import 'package:account/API/vote_complaint.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart' ;
  

Widget like(count,comlaintID){
  return 
  LikeButton(
    likeBuilder: (isLiked) {
        VoteComplaint a=VoteComplaint();
           a.sendVoteRequest(comlaintID).then((response) {
            // Handle the API response if needed
          });
        
      return Icon(
        Icons.volunteer_activism,
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
      
    },
   
    );
  
      
}

