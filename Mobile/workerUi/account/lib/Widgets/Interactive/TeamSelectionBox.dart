import 'package:flutter/material.dart';
import 'package:account/Utils/Team.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Utils/TeamMembers.dart';
import 'package:account/Widgets/Popup/CheckBoxPopup.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Widgets/Displays/TeamMemberDisplay.dart';
// ignore_for_file: file_names


class TeamSelectionBox extends StatefulWidget {
  final double height;
  final double width;
  final double boxHeight;
  final double boxWidth;
  final void Function(Team) onChecked;

  const TeamSelectionBox({
    Key? key,
    required this.height,
    required this.width,
    required this.boxHeight,
    required this.boxWidth,
    required this.onChecked,
  }) : super(key: key);

  @override
  _TeamSelectionBoxState createState() => _TeamSelectionBoxState();
}

class _TeamSelectionBoxState extends State<TeamSelectionBox> {
  late Future<List<TeamMember>> teamMembersRequest;
  List<TeamMember> teamMembersList1 = [
    TeamMember(1, "asd بسام", true),
    TeamMember(2, "عمر احمد", false),
    TeamMember(3, "طلال بلال", false),
    TeamMember(4, "سيف محمد", false),
  ];
  List<TeamMember> teamMembersList2 = [
    TeamMember(1, "محمد بسام", false),
    TeamMember(2, "عمر احمد", true),
    TeamMember(3, "طلال بلال", false),
    TeamMember(4, "سيف محمد", false),
  ];
  List<TeamMember> teamMembersList3 = [
    TeamMember(1, "محمد بسام", false),
    TeamMember(2, "عمر احمد", false),
    TeamMember(3, "طلال بلال", true),
    TeamMember(4, "سيف محمد", false),
  ];
  List<TeamMember> teamMembersList4 = [
    TeamMember(1, "محمد بسام", false),
    TeamMember(2, "عمر احمد", false),
    TeamMember(3, "طلال بلال", false),
    TeamMember(4, "سيف محمد", true),
  ];
  late Future<List<Team>> teamsRequest;
  List<Team> teamsList = [
    Team(1, "asd بسام"),
    Team(2, "عمر احمد"),
    Team(3, "طلال بلال"),
    Team(4, "سيف محمد"),
  ];

  List<TeamMember> getSelectedTeam() {
    switch (selectedTeamId) {
      case 1:
        return teamMembersList1;
      case 2:
        return teamMembersList2;
      case 3:
        return teamMembersList3;
      case 4:
        return teamMembersList4;
      default:
        return [];
    }
  }

  int selectedTeamId = 0;
  List<Team> filteredTeams = [];

  @override
  void initState() {
    super.initState();
    getTeams();
    getTeamMembers();
    filteredTeams.addAll(teamsList);
  }

  void getTeamMembers() async {
    teamMembersRequest = Future.delayed(
        const Duration(milliseconds: 300), () => getSelectedTeam());
  }

  void getTeams() async {
    teamsRequest =
        Future.delayed(const Duration(milliseconds: 300), () => teamsList);
    teamsList = await teamsRequest;
  }

  void filterTeams(String query, void Function(void Function()) refresh) {
    if (query.isEmpty) {
      setState(() {
        filteredTeams = teamsList;
      });
      refresh(() => {});
      return;
    }
    setState(() {
      filteredTeams = teamsList
          .where((team) => team.strLeaderName.contains(query))
          .toList();
      refresh(() => {});
    });
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
                  FutureBuilder(
                      future: teamsRequest,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: StyledButton(
                            height: widget.height * 0.165,
                            text: "اختر فريق",
                            fontSize: 14,
                            onPressed: () => {},
                            isLoading: true,
                          ));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        return StyledButton(
                          text: "اختر فريق",
                          fontSize: 14,
                          onPressed: () {
                            setState(() {
                              filterTeams("", (p0) => {});
                            });
                            showDialog(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                  builder: (context, setStateInsideDialog) {
                                return CheckBoxPopup(
                                  height: screenHeight * 0.5,
                                  title: "الفرق",
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
                                        setState(() {});
                                        setStateInsideDialog(() {
                                          selectedTeamId =
                                              filteredTeams[index].intId;
                                          widget
                                              .onChecked(filteredTeams[index]);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        );
                      }),
                  const TitleText(
                    text: "فريق العمل",
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
                    getSelectedTeam().isEmpty) {
                  return SizedBox(
                    height: widget.boxHeight,
                    child: const Center(
                        child: TitleText(text: "لم يتم اختيار شعبة")),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<TeamMember> team = getSelectedTeam();

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
                              : Icons.emoji_emotions,
                          color: team[index].blnIsLeader
                              ? AppColor.main
                              : AppColor.textTitle,
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
