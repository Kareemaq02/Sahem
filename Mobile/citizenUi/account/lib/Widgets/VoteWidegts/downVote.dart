import 'package:flutter/material.dart';
import 'package:account/API/vote_complaint.dart';
import 'package:account/Widgets/VoteWidegts/voteButton.dart';

// ignore_for_file: unused_local_variable, file_names, prefer_const_constructors
class DownVote extends StatefulWidget {
  int initialCount;
  final int complaintID;
  final int isVoted;
  final ValueChanged<VoteInfo> onVoteChanged;

  DownVote({
    required this.initialCount,
    required this.complaintID,
    required this.isVoted,
    required this.onVoteChanged,
  });

  @override
  _DownVoteState createState() => _DownVoteState();
}

class _DownVoteState extends State<DownVote> {
  VoteComplaint a = VoteComplaint();

  @override
  Widget build(BuildContext context) {
    bool isActive = widget.isVoted == -1;

    return GestureDetector(
      onTap: () async {
        if (!isActive) {
          if (widget.isVoted == 1) {
            await a.removeVoteRequest(widget.complaintID, context);
          }
          await a.DownVoteRequest(widget.complaintID, context);
          widget.initialCount--;
        } else {
          await a.removeVoteRequest(widget.complaintID, context);
          widget.initialCount++;
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
                  "assets/icons/downActive.png",
                  scale: 1.1,
                )
              : Image.asset(
                  "assets/icons/downInactive.png",
                  scale: 1.1,
                ),
        ],
      ),
    );
  }
}

