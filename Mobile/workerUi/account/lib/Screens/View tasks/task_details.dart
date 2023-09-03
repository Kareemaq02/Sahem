import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/API/TaskAPI/view_tasks_request.dart';
import 'package:account/Widgets/TaskCard/timeLineVertical.dart';
import 'package:account/Widgets/HelperWidgets/myContainer.dart';
// ignore_for_file: library_private_types_in_public_api

class ComplaintDetailsScreen extends StatefulWidget {
  final List<TaskModel> tasks;

  const ComplaintDetailsScreen({super.key, required this.tasks});

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
  Widget build(BuildContext context) {
    TaskModel task = widget.tasks.first;
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
      bottomNavigationBar: BottomNavBar1(0),
      appBar: myAppBar(context, 'الأعمال', false, screenHeight * 0.3),
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
                              position], // Use the correct image path here
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
              child: Mycontainer(
                screenHeight * 0.2,
                //foregroundDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.01),
                  child: Column(children: [
                    RowInfo("رقم العمل", task.taskId.toString()),
                    RowInfo("تاريخ الاضافة ",
                        task.activatedDate.toString().substring(0, 10)),
                    RowInfo("نوع البلاغ", task.strTypeNameAr.toString()),
                    RowInfo(
                      "موقع البلاغ",
                      "ش.وصفي التل ,عمان",
                    ),
                  ]),
                ),
              ),
            ),

            // //satus details
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Mycontainer(
                screenHeight * 0.68,
                Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.10),
                  child: timeLineVertical(),
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
       
        Text(
          title,
          style: const TextStyle(
            color: AppColor.main,
            fontFamily: 'DroidArabicKufi',
            fontSize: 13,
          ),
         // textDirection: TextDirection.rtl,
        ),
         Text(
          value,
          //textDirection: TextDirection,
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
