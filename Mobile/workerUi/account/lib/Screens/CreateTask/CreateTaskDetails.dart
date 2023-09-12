import 'package:account/API/TaskAPI/Get_Tasks_Types_Request.dart';
import 'package:account/Screens/Results/FailurePage.dart';
import 'package:account/Screens/Results/SuccessPage.dart';
import 'package:account/Utils/DateFormatter.dart';
import 'package:account/Utils/DropDownValue.dart';
import 'package:account/Utils/Team.dart';
import 'package:account/Widgets/Buttons/OutlinedStyledButton.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/DropDown/StyledDropDown.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/Interactive/DateRangeField.dart';
import 'package:account/Widgets/Interactive/FormTextField.dart';
import 'package:account/Widgets/Interactive/TeamSelectionBox.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// ignore_for_file: library_private_types_in_public_api
class CreateTaskDetails extends StatefulWidget {
  final int intComplaintId;
  const CreateTaskDetails({super.key, required this.intComplaintId});

  @override
  _CreateTaskDetailsState createState() => _CreateTaskDetailsState();
}

class _CreateTaskDetailsState extends State<CreateTaskDetails> {
  // Render Vars

  // API Vars
  late Future<List<TaskType>> taskTypesRequest;
  List<TaskType> taskTypesList = [];
  int pageNumber = 1;

  // Request Vars
  TextEditingController costController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  late DropDownValue selectedType;
  Team selectedTeam = Team(0, "0");
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    getTaskTypes();
  }

  // API Functions
  void getTaskTypes() async {
    taskTypesRequest = TaskTypeRequest().getAllCategory();
    taskTypesList = await taskTypesRequest;
    selectedType =
        DropDownValue(taskTypesList.first.intId, taskTypesList.first.strNameAr);
  }

  void setSelectedType(DropDownValue type) {
    selectedType = type;
  }

  void setTeam(Team team) {
    selectedTeam = team;
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

  void _sendRequest() async {
    //use dio if http doesn't work
    Map<String, dynamic> data = {
      'scheduledDate': startDate,
      'deadlineDate': endDate,
      'strComment': commentController.text,
      'intTaskType': selectedType.intID,
      'intTeamId': selectedTeam.intId,
      'lstComplaintIds': [widget.intComplaintId],
    };
    print(data);
    // final response = await request(data)
    // if (response.statusCode == 200) {

    var statusCode = 200;
    // var statusCode = 400;
    if (statusCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: const SuccessPage(
              text: 'تم اضافة المهمه بنجاح!',
            ),
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: const FailurePage(
              text: 'لم يتم اضافة المهمه!',
            ),
          ),
        ),
      );
    }
  }
  //

  // Render Functions
  Timer? _snackBarTimer;
  void _showSnackbar(BuildContext context, text) {
    _snackBarTimer?.cancel();

    SnackBar snackBar = SnackBar(
      content: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'DroidArabicKufi'),
        ),
      ),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    _snackBarTimer = Timer(snackBar.duration, () {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    });
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
      appBar: myAppBar(context, 'اضافة عمل', false, screenHeight * 0.28),
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
            contentPadding: EdgeInsets.only(top: fieldHeight * 0.22),
            icon: Icons.monetization_on_outlined,
          ),
          // Team Box
          TeamSelectionBox(
            height: fieldHeight * 4,
            width: fieldWidth,
            boxHeight: boxHeight,
            boxWidth: boxWidth,
            onChecked: setTeam,
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
            onPressed: () {
              if (selectedTeam.intId == 0) {
                _showSnackbar(context, "لم يتم اختيار شعبة الرجاء اضافة واحده");
                return;
              }
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      height: screenHeight * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.08,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: screenHeight * 0.01,
                              ),
                              child: const TitleText(
                                text: "تأكيد المهمه",
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: fieldHeight * 0.2,
                                  horizontal: fieldWidth * 0.1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedType.strName,
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      color: AppColor.main,
                                      fontSize: 14,
                                      fontFamily: 'DroidArabicKufi',
                                    ),
                                  ),
                                  const TitleText(text: "نوع المهمه:")
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: fieldHeight * 0.2,
                                  horizontal: fieldWidth * 0.1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatDate(startDate),
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      color: AppColor.main,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'DroidArabicKufi',
                                    ),
                                  ),
                                  const TitleText(text: "تاريخ البدء:")
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: fieldHeight * 0.2,
                                  horizontal: fieldWidth * 0.1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatDate(endDate),
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      color: AppColor.main,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'DroidArabicKufi',
                                    ),
                                  ),
                                  const TitleText(text: "تاريخ الانتهاء:")
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: fieldHeight * 0.2,
                                  horizontal: fieldWidth * 0.1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    costController.text.isNotEmpty
                                        ? costController.text
                                        : "غير محدد",
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      color: AppColor.main,
                                      fontSize: 14,
                                      fontFamily: 'DroidArabicKufi',
                                    ),
                                  ),
                                  const TitleText(text: "التكلفة:")
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: fieldHeight * 0.2,
                                  horizontal: fieldWidth * 0.1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedTeam.strLeaderName,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      color: AppColor.main,
                                      fontSize: 14,
                                      fontFamily: 'DroidArabicKufi',
                                    ),
                                  ),
                                  const TitleText(text: "رئيس الشعبة:")
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: fieldHeight * 0.2,
                                  horizontal: fieldWidth * 0.1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedStyledButton(
                                    text: "الغاء",
                                    fontSize: 14,
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  StyledButton(
                                    text: "موافق",
                                    fontSize: 14,
                                    onPressed: _sendRequest,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
