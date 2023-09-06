import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart' ;
import 'package:account/API/vote_complaint.dart';

// ignore_for_file: unused_local_variable, file_names, prefer_const_constructors

  

class DownWidget extends StatefulWidget {
 final int initialCount;
  final int complaintID;
  final int isVoted;
    DownWidget({
    required this.initialCount,
    required this.complaintID,
    required this.isVoted,
  });

  @override
  _DownWidgetState createState() => _DownWidgetState();
}
class _DownWidgetState extends State<DownWidget> {



  int countPress=0;
  VoteComplaint a = VoteComplaint();

  @override
  void initState() {
    super.initState();
    countPress = widget.isVoted;
    // print("here is init count: ${widget.initialCount} ${widget.complaintID}");
    // print("here is : ${widget.isVoted}");

  
  }




 @override
  Widget build(BuildContext context) {
   

  return 
  LikeButton(
    likeBuilder: (isLiked) {
       return 
       isLiked
            ? Image.asset(
                "assets/icons/downActive.png",
                scale: 1.1,
              )
            :
       Image.asset("assets/icons/downInactive.png",scale: 1.1,) ;
    }, 
   onTap: (isLiked) async {

      if (!isLiked && countPress==0) {

       
          //  await a.DownVoteRequest(widget.complaintID,context);
          //  countPress=1;
         
      }
      else if(countPress==1){
          // await a.removeVoteRequest(widget.complaintID,context);
          // countPress=0;
         
        
        
      }
      
      return !isLiked;
    },
       
    );
    
}

}

