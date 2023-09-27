import 'package:account/API/ComplaintsAPI/View_Complaints_Request.dart';
import 'package:account/Widgets/Bars/NavBarAdmin.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/HelperWidgets/Base64ImageDisplay.dart';
import 'package:account/Widgets/HelperWidgets/Loader.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/HelperWidgets/rowInfo.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';

class AddComplaintPage extends StatefulWidget {
  final List<ComplaintModel> lstComplaints;
  final Function(ComplaintModel) onAddComplaint;

  const AddComplaintPage(
      {super.key, required this.onAddComplaint, required this.lstComplaints});

  @override
  _AddComplaintPageState createState() => _AddComplaintPageState();
}

class _AddComplaintPageState extends State<AddComplaintPage> {
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

    complaints = complaints
        .where((element) => !widget.lstComplaints.any((existingComplaint) =>
            existingComplaint.intComplaintId == element.intComplaintId))
        .toList();
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavBarAdmin(3),
      appBar: myAppBar(context, 'إضافة مهمة', false, screenHeight * 0.29),
      body: FutureBuilder<List<ComplaintModel>>(
        future: complaintsRequest,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<ComplaintModel> complaintsList =
              complaints.length > 1 ? complaints : snapshot.data!;
          if (complaintsList.isEmpty) {
            return const Center(
                child: TitleText(text: "لا يوجد بلاغات فالوقت الحالي."));
          }
          return SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
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
                        screenHeight * 0.7,
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.01),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.45,
                                child: PageIndicatorContainer(
                                  align: IndicatorAlign.bottom,
                                  length: complaint.lstMedia.length,
                                  indicatorSpace: 10.0,
                                  padding: const EdgeInsets.all(15),
                                  indicatorColor: Colors.grey,
                                  indicatorSelectorColor: Colors.blue,
                                  shape: IndicatorShape.circle(size: 7),
                                  child: PageView.builder(
                                    itemCount: complaint.lstMedia.length,
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
                                            child: Base64ImageDisplay(
                                                complaint.lstMedia[position]),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03),
                                child: Column(
                                  children: [
                                    RowInfo(
                                      "رقم البلاغ",
                                      complaint.intComplaintId.toString(),
                                    ),
                                    RowInfo(
                                      "تاريخ الإضافة ",
                                      complaint.dtmDateCreated
                                          .toString()
                                          .substring(0, 10),
                                    ),
                                    RowInfo(
                                      "نوع البلاغ",
                                      complaint.strComplaintTypeAr.toString(),
                                    ),
                                    RowInfo(
                                      "موقع البلاغ",
                                      "ش.وصفي التل ,عمان",
                                    ),
                                    RowInfo(
                                      "الأولوية",
                                      "${(complaint.decPriority * 100).toStringAsFixed(1)}%",
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.008,
                              ),
                              StyledButton(
                                text: "إضافة",
                                fontSize: 14,
                                onPressed: () {
                                  widget.onAddComplaint(complaint);
                                  Navigator.of(context).pop();
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
                    ? const Loader()
                    : SizedBox(
                        height: screenHeight * 0.02,
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
