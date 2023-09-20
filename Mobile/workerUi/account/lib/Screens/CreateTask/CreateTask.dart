import 'package:account/API/ComplaintsAPI/View_Complaints_Request.dart';
import 'package:account/Screens/CreateTask/CreateTaskDetails.dart';
import 'package:account/Utils/NaviTranstion.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  // Render Vars
  bool isLoading = false;
  int selectedIndex = 0;

  // API vars
  late Future<List<ComplaintModel>> complaintsRequest;
  List<ComplaintModel> complaints = [];
  int pageNumber = 1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getComplaintsList();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreComplaints();
    }
  }

  void getComplaintsList() async {
    complaintsRequest = PendingComplaints().fetchPendingComplaints(pageNumber);
    complaints = await complaintsRequest;
  }

  void loadMoreComplaints() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      List<ComplaintModel> moreComplaints =
          await PendingComplaints().fetchPendingComplaints(++pageNumber);

      setState(() {
        complaints.addAll(moreComplaints);
        isLoading = false;
      });
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

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar1(0),
      appBar: myAppBar(context, 'اضافة عمل', false, screenHeight * 0.28),
      body: SingleChildScrollView(
        controller: _scrollController,
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
                        screenHeight * 0.69,
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.01),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.5,
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
                              RowInfo(complaint.intComplaintId.toString(),
                                  ":رقم البلاغ", screenWidth * 0.02),
                              RowInfo(
                                  complaint.dtmDateCreated
                                      .toString()
                                      .substring(0, 10),
                                  ":تاريخ الاضافة ",
                                  screenWidth * 0.02),
                              RowInfo(complaint.strComplaintTypeAr.toString(),
                                  ":نوع البلاغ", screenWidth * 0.02),
                              RowInfo("ش.وصفي التل ,عمان", ":موقع البلاغ",
                                  screenWidth * 0.02),
                              StyledButton(
                                text: "اضافه",
                                fontSize: 14,
                                onPressed: () => {
                                  naviTransition(
                                    context,
                                    CreateTaskDetails(
                                      intComplaintId: complaint.intComplaintId,
                                    ),
                                  )
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                isLoading
                    ? Padding(
                        padding: EdgeInsets.all(screenHeight * 0.02),
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: AppColor.main,
                        )),
                      )
                    : SizedBox(
                        height: screenHeight * 0.02,
                      )
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget RowInfo(title, value, padding) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColor.main,
            fontFamily: 'DroidArabicKufi',
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColor.secondary,
            fontFamily: 'DroidArabicKufi',
            fontSize: 10,
          ),
        ),
      ],
    ),
  );
}
