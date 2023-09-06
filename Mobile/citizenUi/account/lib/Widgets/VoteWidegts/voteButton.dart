import 'package:flutter/material.dart';
import 'package:account/API/vote_complaint.dart';

// ignore_for_file: unused_local_variable, file_names, prefer_const_constructors
class VoteWidget extends StatefulWidget {
  int initialCount;
  final int complaintID;
  final int isVoted;
  final ValueChanged<VoteInfo> onVoteChanged;

  VoteWidget({
    required this.initialCount,
    required this.complaintID,
    required this.isVoted,
    required this.onVoteChanged,
  });

  @override
  _VoteWidgetState createState() => _VoteWidgetState();
}

class _VoteWidgetState extends State<VoteWidget> {
  VoteComplaint a = VoteComplaint();
  int onPressed = 0;

  @override
  Widget build(BuildContext context) {
    bool isActive = widget.isVoted == 1;

    return GestureDetector(
      onTap: () async {
        if (!isActive) {
          if (widget.isVoted == -1) {
            await a.removeVoteRequest(widget.complaintID, context);
          }
          await a.sendVoteRequest(widget.complaintID, context);
          onPressed = 1;
          widget.initialCount++;
        } else {
          await a.removeVoteRequest(widget.complaintID, context);
          widget.initialCount--;
          onPressed = 0;
        }

        widget.onVoteChanged(
          VoteInfo(
            isActive ? widget.initialCount : widget.initialCount,
            !isActive,
          ),
        );
      },
      child: Column(
        children: [
          isActive
              ? Image.asset(
                  "assets/icons/upActive.png",
                  scale: 1.1,
                )
              : Image.asset(
                  "assets/icons/upInactive.png",
                  scale: 1.1,
                ),
        ],
      ),
    );
  }
}

class VoteInfo {
  final int count;
  final bool isLiked;

  VoteInfo(this.count, this.isLiked);
}
