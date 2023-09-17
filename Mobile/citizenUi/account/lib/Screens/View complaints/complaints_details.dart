import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/API/complaint_requests.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/HelperWidegts/myContainer.dart';
import 'package:account/Widgets/ComaplaintCard/timeLineVertical.dart';
// ignore_for_file: non_constant_identifier_names



// ignore_for_file: library_private_types_in_public_api

class ComplaintDetailsScreen extends StatefulWidget {
  final List<ComplaintModel> complaints;
  final String address;

  const ComplaintDetailsScreen(
      {super.key, required this.complaints, required this.address});

  @override
  _ComplaintViewState createState() => _ComplaintViewState();
}

class _ComplaintViewState extends State<ComplaintDetailsScreen> {
  final List<String> imageList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
  ];

  int selectedIndex = 0;


  @override
  void initState() {
    super.initState();
  }


  
 

  @override
  Widget build(BuildContext context) {
    ComplaintModel complaint = widget.complaints.first;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


//   List<String> getImageUrls() {
//   List<String> imageUrls = [];
//   for (var media in task.lstMedia) {
//     imageUrls.add(media.data); // Add the media data (URL) to the list
//   }
//   return imageUrls;
// }
//List<String> urls = getImageUrls();
//print(urls);

    // List<String> imageUrls = getImageUrls();

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton: const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar1(2),
      appBar: myAppBar(context, 'بلاغاتي', false, screenHeight * 0.3),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //pageview
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
                    return Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                      child: Container(
                        //height: ,
                        color: AppColor.background,
                        child: Image.network(
                          imageList[
                              position], 
                          scale: 0.1,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // //complaintinfo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: myContainer(
                screenHeight * 0.2,
                //foregroundDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.01),
                  child: Column(children: [
                    RowInfo("رقم البلاغ", complaint.intComplaintId.toString()),
                    RowInfo("تاريخ الاضافة ",
                        complaint.dtmDateCreated.toString().substring(0, 10)),
                    RowInfo(
                        "نوع البلاغ", complaint.strComplaintTypeAr.toString()),
                    RowInfo(
                      "موقع البلاغ",
                      widget.address,
                    ),
                  ]),
                ),
              ),
            ),

            // //satus details
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: myContainer(
                screenHeight * 0.50,
                Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.10),
                  child: timeLineVertical(complaint.intComplaintId),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget RowInfo(title, value) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //title
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            value,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: AppColor.secondary,
              fontFamily: 'DroidArabicKufi',
              fontSize: 10,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            title,
            style: const TextStyle(
              color: AppColor.main,
              fontFamily: 'DroidArabicKufi',
              fontSize: 13,
            ),
            // textDirection: TextDirection.rtl,
          ),
        ),
       
      ],
    ),
  );
}
