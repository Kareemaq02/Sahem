import 'package:account/Repository/color.dart';
import 'package:account/Utils/TeamMembers.dart';
import 'package:account/Widgets/Displays/TeamMemberDisplay.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:flutter/material.dart';

class TeamViewBox extends StatelessWidget {
  final double height;
  final double width;
  final double boxHeight;
  final double boxWidth;
  final List<TeamMember> teamMembers;

  const TeamViewBox({
    Key? key,
    required this.height,
    required this.width,
    required this.boxHeight,
    required this.boxWidth,
    required this.teamMembers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: const TitleText(
                text: "فريق العمل",
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              children: List.generate(
                teamMembers.length,
                (index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: TeamMemberDisplay(
                      height: boxHeight,
                      width: boxWidth,
                      name: teamMembers[index].strName,
                      icon: teamMembers[index].blnIsLeader
                          ? Icons.flag_circle_rounded
                          : Icons.emoji_emotions,
                      color: teamMembers[index].blnIsLeader
                          ? AppColor.main
                          : AppColor.textTitle,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
