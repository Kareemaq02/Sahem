import 'package:account/API/TaskAPI/Get_Tasks_Types_Request.dart';
import 'package:account/Utils/DropDownValue.dart';
import 'package:account/Utils/TeamMembers.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/DropDown/StyledDropDown.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/Interactive/DateRangeField.dart';
import 'package:account/Widgets/Interactive/FormTextField.dart';
import 'package:account/Widgets/Interactive/TeamSelectionBox.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';

// ignore_for_file: library_private_types_in_public_api
class CreateTaskDetails extends StatefulWidget {
  const CreateTaskDetails({super.key});

  @override
  _CreateTaskDetailsState createState() => _CreateTaskDetailsState();
}

class _CreateTaskDetailsState extends State<CreateTaskDetails> {
  // Render Vars

  // API Vars
  late Future<List<TaskType>> taskTypesRequest;
  List<TaskType> taskTypesList = [];
  late Future<List<TeamMembers>> teamMembersRequest;
  List<TeamMembers> teamMembersList = [
    TeamMembers(1, "محمد بسام", false),
    TeamMembers(2, "عمر احمد", true),
    TeamMembers(3, "طلال بلال", false),
    TeamMembers(4, "سيف محمد", false),
  ];
  int pageNumber = 1;

  // Request Vars
  TextEditingController costController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  late int selectedTypeId;
  late int selectedTeamId;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    getTaskTypes();
    getTeamMembers();
  }

  // API Functions
  void getTaskTypes() async {
    taskTypesRequest = TaskTypeRequest().getAllCategory();
    taskTypesList = await taskTypesRequest;
  }

  void getTeamMembers() async {
    teamMembersRequest = Future.delayed(
        const Duration(milliseconds: 300), () => teamMembersList);
    teamMembersList = await teamMembersRequest;
  }

  void setSelectedType(DropDownValue typeId) {
    selectedTypeId = typeId.intID;
  }

  void setTeamType(int teamId) {
    selectedTeamId = teamId;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    PickerDateRange dateRange = args.value;
    if (dateRange.endDate != null) {
      setState(() {
        startDate = dateRange.startDate!;
        endDate = dateRange.endDate!;
      });
    }
  }
  //

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double fieldWidth = screenWidth * 0.92;
    double fieldHeight = screenHeight * 0.06;

    double boxWidth = screenWidth * 0.3;
    double boxHeight = screenHeight * 0.15;

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar1(0),
      appBar: myAppBar(context, 'اضافة عمل', false, screenHeight * 0.3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Types Box
          FutureBuilder<List<TaskType>>(
            future: taskTypesRequest,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              List<DropDownValue> values = taskTypesList
                  .map((type) => DropDownValue(type.intId, type.strNameAr))
                  .toList();
              return Center(
                child: TasksDropDown(
                  width: fieldWidth,
                  valuesList: values,
                  onSelect: setSelectedType,
                ),
              );
            },
          ),
          // DateRange Box
          DateRangeField(
            height: fieldHeight,
            width: fieldWidth,
            onSelectionChanged: _onSelectionChanged,
            initialRange: PickerDateRange(startDate, endDate),
          ),
          // Cost Box
          FormTextField(
            height: fieldHeight,
            width: fieldWidth,
            controller: costController,
            hintText: "التكلفة",
            isDigitsOnly: true,
            icon: Icons.monetization_on_outlined,
          ),
          // Team Box
          TeamSelectionBox(
            height: fieldHeight * 4,
            width: fieldWidth,
            teamRequest: teamMembersRequest,
            teamList: teamMembersList,
            boxHeight: boxHeight,
            boxWidth: boxWidth,
          ),
          // Comment Box
          FormTextField(
            height: fieldHeight * 4,
            width: fieldWidth,
            controller: commentController,
            hintText: "اضف تعليق",
          ),
          // Submit Button
          StyledButton(
            height: fieldHeight,
            width: fieldWidth / 2,
            text: "استمرار",
            fontSize: 16,
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
