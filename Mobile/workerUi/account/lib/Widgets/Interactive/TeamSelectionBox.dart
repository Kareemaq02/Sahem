import 'package:flutter/material.dart';
import 'package:account/Utils/Team.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Utils/TeamMembers.dart';
import 'package:account/API/TeamsAPI/GetTeamMembers.dart';
import 'package:account/Widgets/Popup/CheckBoxPopup.dart';
import 'package:account/Widgets/HelperWidgets/Loader.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/API/TeamsAPI/GetAvailableTeams.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Widgets/Displays/TeamMemberDisplay.dart';
// ignore_for_file: duplicate_ignore

// ignore_for_file: file_names

// ignore: file_names

class TeamSelectionBox extends StatefulWidget {
  final double height;
  final double width;
  final double boxHeight;
  final double boxWidth;
  final DateTime startDate;
  final DateTime endDate;
  final void Function(Team) onChecked;

  const TeamSelectionBox({
    Key? key,
    required this.height,
    required this.width,
    required this.boxHeight,
    required this.boxWidth,
    required this.onChecked,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  _TeamSelectionBoxState createState() => _TeamSelectionBoxState();
}

class _TeamSelectionBoxState extends State<TeamSelectionBox> {
  late Future<List<TeamMember>> teamMembersRequest;
  List<TeamMember> teamMembersList = [];

  late Future<List<Team>> teamsRequest;
  List<Team> teamsList = [];

  int selectedTeamId = 0;
  List<Team> filteredTeams = [];

  @override
  void initState() {
    super.initState();
    setIntialTeam();
  }

  void setIntialTeam() async {
    teamMembersRequest = Future.delayed(const Duration(milliseconds: 300))
        .then((value) => <TeamMember>[]);
  }

  void getTeamMembers() async {
    print(selectedTeamId);
    teamMembersRequest = GetTeamMembersRequest().getTeamMembers(selectedTeamId);
    teamMembersList = await teamMembersRequest;
    print(teamMembersList.map((e) => e.intId));
  }

  void getTeams() async {
    teamsRequest = AvailableTeamsRequest()
        .getAvailableTeams(widget.startDate, widget.endDate);
    teamsList = await teamsRequest;
    filteredTeams.clear();
    filteredTeams.addAll(teamsList);
  }

  void filterTeams(String query, void Function(void Function()) refresh) {
    if (query.isEmpty) {
      setState(() {
        filteredTeams = teamsList;
      });
      refresh(() => {});
      return;
    }
    setState(
      () {
        filteredTeams = teamsList
            .where((team) => team.strLeaderName.contains(query))
            .toList();
        refresh(() => {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledButton(
                    text: "إختر",
                    fontSize: 14,
                    onPressed: () {
                      getTeams();
                      setState(() {
                        filterTeams("", (p0) => {});
                      });
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setStateInsideDialog) {
                            return FutureBuilder(
                              future: teamsRequest,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: SizedBox(
                                      height: screenHeight * 0.5,
                                      child: const Loader(),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }
                                return CheckBoxPopup(
                                  height: screenHeight * 0.5,
                                  title: "الشعب",
                                  search: (String query) =>
                                      filterTeams(query, setStateInsideDialog),
                                  checkBoxes: List.generate(
                                    filteredTeams.length,
                                    (index) => StyledCheckBox(
                                      text: filteredTeams[index].strLeaderName,
                                      fontSize: 16,
                                      isChecked: selectedTeamId ==
                                          filteredTeams[index].intId,
                                      onChanged: () {
                                        setStateInsideDialog(
                                          () {
                                            selectedTeamId =
                                                filteredTeams[index].intId;
                                            widget.onChecked(
                                                filteredTeams[index]);
                                          },
                                        );
                                        setState(() {
                                          getTeamMembers();
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const TitleText(
                    text: "الشعبة",
                  ),
                ],
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
