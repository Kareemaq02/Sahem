import 'package:account/API/TeamsAPI/GetTeamAnalytics.dart';
import 'package:account/API/TeamsAPI/GetTeamByLeaderId.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Widgets/Displays/TeamMemberAnalyticsDisplay.dart';
import 'package:account/Widgets/HelperWidgets/Loader.dart';
import 'package:flutter/material.dart';
import 'package:account/Utils/Team.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/Displays/TeamMemberDisplay.dart';

class TeamAnalyticsBoxLeader extends StatefulWidget {
  final double height;
  final double width;
  final double boxHeight;
  final double boxWidth;
  final void Function(Team) onChecked;

  const TeamAnalyticsBoxLeader({
    Key? key,
    required this.height,
    required this.width,
    required this.boxHeight,
    required this.boxWidth,
    required this.onChecked,
  }) : super(key: key);

  @override
  _TeamAnalyticsBoxLeaderState createState() => _TeamAnalyticsBoxLeaderState();
}

class _TeamAnalyticsBoxLeaderState extends State<TeamAnalyticsBoxLeader> {
  late Future<TeamAnalyticsModel> teamMembersRequest;
  List<TeamMembersRating> teamMembersList = [];

  int selectedTeamId = 0;

  @override
  void initState() {
    super.initState();
    setIntialTeam();
  }

  void setIntialTeam() async {
    teamMembersRequest = Future.delayed(const Duration(milliseconds: 300)).then(
      (value) => TeamAnalyticsModel(
          intTeamId: 0,
          intTasksCount: 0,
          intTasksCompletedCount: 0,
          intTasksScheduledCount: 0,
          intTasksIncompleteCount: 0,
          intTasksWaitingEvaluationCount: 0,
          decTeamRatingAvg: 0.0,
          lstMembersAvgRating: <TeamMembersRating>[]),
    );
    var leaderId = getUserData().intId;
    var team = await TeamByLeaderRequest().getTeam(leaderId);
    selectedTeamId = team.intId;
    widget.onChecked(team);
    getTeamMembers();
  }

  void getTeamMembers() async {
    teamMembersRequest =
        TeamsAnalyticsRequest().getTeamsAnalytics(selectedTeamId);
    var _ = await teamMembersRequest;
    teamMembersList = _.lstMembersAvgRating;
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TitleText(
                    text: "الشعبة",
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: FutureBuilder<TeamAnalyticsModel>(
              future: teamMembersRequest,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    teamMembersList.isEmpty) {
                  return SizedBox(
                    height: widget.boxHeight,
                    child: const Loader(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<TeamMembersRating> team = teamMembersList;

                return Row(
                  children: List.generate(
                    team.length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: team[index].blnIsLeader
                            ? TeamMemberDisplay(
                                height: widget.boxHeight,
                                width: widget.boxWidth,
                                name: team[index].strName,
                                icon: Icons.flag_circle_rounded,
                                color: AppColor.main,
                              )
                            : TeamMemberAnalyticsDisplay(
                                height: widget.boxHeight,
                                width: widget.boxWidth,
                                name: team[index].strName,
                                icon: Icons.emoji_emotions_outlined,
                                color: AppColor.secondary,
                                rating: team[index].decRating,
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
