import 'package:account/Repository/color.dart';
import 'package:account/Utils/Team.dart';
import 'package:account/Utils/TeamMembers.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Widgets/Displays/TeamDisplay.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/Popup/CheckBoxPopup.dart';
import 'package:flutter/material.dart';

class TeamSelectionBox extends StatefulWidget {
  final double height;
  final double width;
  final Future<List<TeamMembers>> teamRequest;
  final List<TeamMembers> teamList;
  final double boxHeight;
  final double boxWidth;

  const TeamSelectionBox({
    Key? key,
    required this.height,
    required this.width,
    required this.teamRequest,
    required this.teamList,
    required this.boxHeight,
    required this.boxWidth,
  }) : super(key: key);

  @override
  _TeamSelectionBoxState createState() => _TeamSelectionBoxState();
}

class _TeamSelectionBoxState extends State<TeamSelectionBox> {
  late Future<List<Team>> teamsRequest;
  List<Team> teamsList = [
    Team(1, "محمد بسام"),
    Team(2, "عمر احمد"),
    Team(3, "طلال بلال"),
    Team(4, "سيف محمد"),
  ];

  @override
  void initState() {
    super.initState();
    getTeams();
  }

  void getTeams() async {
    teamsRequest =
        Future.delayed(const Duration(milliseconds: 300), () => teamsList);
    teamsList = await teamsRequest;
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
                            CheckBoxPopup(
                              height: screenHeight * 0.5,
                              title: "الفرق",
                            ).showCheckBoxDialog(
                              context,
                              List.generate(
                                teamsList.length,
                                (index) => StyledCheckBox(
                                  text: teamsList[index].strLeaderName,
                                  fontSize: 16,
                                  isChecked: false,
                                  onChanged: () => {},
                                ),
                              ),
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
            child: FutureBuilder<List<TeamMembers>>(
              future: widget.teamRequest,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<TeamMembers> team = widget.teamList.length > 1
                    ? widget.teamList
                    : snapshot.data!;

                return Row(
                  children: List.generate(
                    team.length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: TeamDisplay(
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
