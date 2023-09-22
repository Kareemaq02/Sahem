import 'package:account/API/ComplaintsAPI/View_Complaints_Request.dart';
import 'package:account/Screens/Results/FailurePage.dart';
import 'package:account/Screens/Results/SuccessPage.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Widgets/HelperWidgets/rowInfo.dart';
import 'package:account/Widgets/Interactive/DateRangeField.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TaskIncomplete extends StatefulWidget {
  final int taskId;
  const TaskIncomplete({super.key, required this.taskId});

  @override
  _TaskIncompleteState createState() => _TaskIncompleteState();
}

class _TaskIncompleteState extends State<TaskIncomplete> {
  // API vars
  late Future<List<ComplaintModel>> complaintsRequest;
  List<ComplaintModel> complaints = [];

  // Request Vars
  List<int> incompleteIds = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 7));
  TextEditingController commentController = TextEditingController();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    PickerDateRange dateRange = args.value;
    if (dateRange.endDate != null) {
      setState(() {
        startDate = dateRange.startDate!;
        endDate = dateRange.endDate!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getComplaintsList();
  }

  void getComplaintsList() async {
    // Change to Get task's complaints list
    complaintsRequest = PendingComplaints().fetchPendingComplaints(1);
    complaints = await complaintsRequest;
  }

  void _sendRequest() async {
    //use dio if http doesn't work
    Map<String, dynamic> data = {
      'scheduledDate': startDate,
      'deadlineDate': endDate,
      'strComment': commentController.text,
      'taskId': widget.taskId,
    };
    print(data);
    // final response = await request(data)
    // var statusCode = response.statusCode;
    var statusCode = 200;
    if (statusCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: const SuccessPage(
              text: 'تم تقييم المهمه بنجاح!',
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
              text: 'لم يتم تقييم المهمه!',
            ),
          ),
        ),
      );
    }
  }

  final List<String> imageList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double fieldWidth = screenWidth * 0.92;
    double fieldHeight = screenHeight * 0.06;

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar1(0),
      appBar: myAppBar(context, 'اضافة عمل', false, screenHeight * 0.28),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<List<ComplaintModel>>(
          future: complaintsRequest,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            List<ComplaintModel> complaintsList =
                complaints.length > 1 ? complaints : snapshot.data!;
            return Column(
              children: [
                ...List.generate(
                  complaintsList.length,
                  (index) {
                    ComplaintModel complaint = complaintsList[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.02),
                      child: myContainer(
                        screenHeight * 0.45,
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.01),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.3,
                                child: PageIndicatorContainer(
                                  align: IndicatorAlign.bottom,
                                  length: imageList.length,
                                  indicatorSpace: 10.0,
                                  padding: const EdgeInsets.all(15),
                                  indicatorColor: Colors.grey,
                                  indicatorSelectorColor: Colors.blue,
                                  shape: IndicatorShape.circle(size: 7),
                                  child: PageView.builder(
                                    itemCount: imageList.length,
                                    itemBuilder: (context, position) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenHeight * 0.01,
                                            horizontal: screenWidth * 0.02),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColor.background,
                                            ),
                                            child: Image.network(
                                              imageList[position],
                                              scale: 0.1,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              RowInfo(
                                "رقم البلاغ",
                                complaint.intComplaintId.toString(),
                              ),
                              RowInfo(
                                "نوع البلاغ",
                                complaint.strComplaintTypeAr.toString(),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              StatefulBuilder(
                                builder: (context, setStateCheckBoxes) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          StyledCheckBox(
                                            text: "غير مكتمل",
                                            fontSize: 14,
                                            isChecked: incompleteIds.contains(
                                                complaint.intComplaintId),
                                            onChanged: () {
                                              setStateCheckBoxes(
                                                () => incompleteIds.add(
                                                    complaint.intComplaintId),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.05,
                                          ),
                                          StyledCheckBox(
                                            text: "مكتمل",
                                            fontSize: 14,
                                            isChecked: !incompleteIds.contains(
                                                complaint.intComplaintId),
                                            onChanged: () {
                                              setStateCheckBoxes(() =>
                                                  incompleteIds.remove(complaint
                                                      .intComplaintId));
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                DateRangeField(
                  height: fieldHeight,
                  width: fieldWidth,
                  onSelectionChanged: _onSelectionChanged,
                  initialRange: PickerDateRange(startDate, endDate),
                ),
                const Text(
                  "سيتم اعادة ارسال المهمه**",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 255, 43, 43),
                    fontFamily: 'DroidArabicKufi',
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.3,
                  child: StyledButton(
                    text: "تقييم",
                    fontSize: screenHeight * 0.05 * 0.4,
                    onPressed: _sendRequest,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
