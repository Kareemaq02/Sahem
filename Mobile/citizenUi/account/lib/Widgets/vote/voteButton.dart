// ignore_for_file: unused_local_variable, file_names, prefer_const_constructors

import 'package:account/API/vote_complaint.dart';
import 'package:account/Widgets/countProvider.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart' ;
import 'package:provider/provider.dart';
  

class VoteWidget extends StatefulWidget {
 final int initialCount;
  final int complaintID;
  final int isVoted;
    VoteWidget({
    required this.initialCount,
    required this.complaintID,
    required this.isVoted,
  });

  @override
  _VoteWidgetState createState() => _VoteWidgetState();
}
class _VoteWidgetState extends State<VoteWidget> {



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
    final countProvider = Provider.of<CountProvider>(context, listen: false);
     //countProvider.updateCount(widget.initialCount);

  return 
  LikeButton(
    likeBuilder: (isLiked) {
       return 
       isLiked|| widget.isVoted==1? Image.asset("assets/icons/upActive.png",scale: 1.1,) :
       Image.asset("assets/icons/upInactive.png",scale: 1.1,) ;
    }, 
   onTap: (isLiked) async {

      if (!isLiked && countPress==0) {
      Image.asset("assets/icons/upInactive.png",scale: 1.1,);
       
         await a.sendVoteRequest(widget.complaintID,context);
         countPress=1;
         
      }
      else if(countPress==1){
        await a.removeVoteRequest(widget.complaintID,context);
        countPress=0;
         
        
        
      }
      
      return !isLiked;
    },
       
    );
    
}

}












// Widget downVote(count,comlaintID){
//   return 
//   LikeButton(
//     likeBuilder: (isLiked) {
//        return 
//        isLiked? Image.asset("assets/icons/downActive.png",scale: 1.1,)  :
//        Image.asset("assets/icons/downInactive.png",scale: 1.1,) ;
  
//     },
    

//    onTap: (isLiked) async {
//       if (!isLiked) {
//         VoteComplaint a = VoteComplaint();
//          await a.DownVoteRequest(comlaintID,context);
       
//       }
//       return !isLiked;
//     },
   
//     );
      
// }







