import 'package:account/API/TeamsAPI/GetTeamMembers.dart';
import 'package:flutter/material.dart';
import 'package:account/Utils/Team.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Utils/TeamMembers.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/Displays/TeamMemberDisplay.dart';

class TeamViewBox extends StatefulWidget {
  final int teamId;
  final double height;
  final double width;
  final double boxHeight;
  final double boxWidth;

  const TeamViewBox({
    Key? key,
    required this.teamId,
    required this.height,
    required this.width,
    required this.boxHeight,
    required this.boxWidth,
  }) : super(key: key);

  @override
  _TeamViewBoxState createState() => _TeamViewBoxState();
}

class _TeamViewBoxState extends State<TeamViewBox> {
  late Future<List<TeamMember>> teamMembersRequest;
  List<TeamMember> teamMembersList = [];

  late Future<List<Team>> teamsRequest;
  List<Team> teamsList = [];

  @override
  void initState() {
    super.initState();
    setIntialTeam();
    getTeamMembers();
  }

  void setIntialTeam() async {
    teamMembersRequest = Future.delayed(const Duration(milliseconds: 300))
        .then((value) => <TeamMember>[]);
  }

  void getTeamMembers() async {
    teamMembersRequest = GetTeamMembersRequest().getTeamMembers(widget.teamId);
    teamMembersList = await teamMembersRequest;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: widget.height,
      width: widget.width,
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
                text: "الشعبة",
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: FutureBuilder<List<TeamMember>>(
              future: teamMembersRequest,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    teamMembersList.isEmpty) {
                  return SizedBox(
                    height: widget.boxHeight,
                    child: const Center(
                        child: TitleText(text: "لم يتم اختيار شعبة")),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<TeamMember> team = teamMembersList;

                return Row(
                  children: List.generate(
                    team.length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: TeamMemberDisplay(
                          height: widget.boxHeight,
                          width: widget.boxWidth,
                          name: team[index].strName,
                          icon: team[index].blnIsLeader
                              ? Icons.flag_circle_rounded
                              : Icons.emoji_emotions_outlined,
                          color: team[index].blnIsLeader
                              ? AppColor.main
                              : AppColor.secondary,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
