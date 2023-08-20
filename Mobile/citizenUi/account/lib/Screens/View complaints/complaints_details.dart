
// ignore_for_file: library_private_types_in_public_api

import 'package:account/API/view_complaint_request.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/appBar.dart';
import 'package:account/Widgets/bottomNavBar.dart';
import 'package:account/Widgets/myContainer.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:page_indicator/page_indicator.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final List<ComplaintModel> complaints;

  const ComplaintDetailsScreen({super.key, required this.complaints});

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
  ComplaintModel complaint = widget.complaints.first;

  List<String> getImageUrls() {
  List<String> imageUrls = [];
  for (var media in complaint.lstMedia) {
    imageUrls.add(media.data); // Add the media data (URL) to the list
  }
  return imageUrls;
}
List<String> urls = getImageUrls();
//print(urls); 

 // List<String> imageUrls = getImageUrls();

   
    return  Scaffold(

      backgroundColor:AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton:const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:  BottomNavBar1(0),
      appBar:myAppBar(context,'بلاغاتي',true,130),
      body:
       SingleChildScrollView(
        scrollDirection: Axis.vertical,
         child: Column(
          children: [
            //pageview
             SizedBox(
              height: 300,
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
                          imageList[position], // Use the correct image path here
                          scale: 0.1,
                          fit:BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
             // //complaintinfo
            Padding(
              padding: const EdgeInsets.only(left:10.0,right: 10.0),
              child: Mycontainer(130,
                //foregroundDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children:[
                      RowInfo("رقم البلاغ",complaint.intComplaintId.toString()),
                      RowInfo("تاريخ الاضافة ",complaint.dtmDateCreated.toString()),
                      RowInfo("نوع البلاغ",complaint.strComplaintTypeAr.toString()),
                      RowInfo("موقع البلاغ","ش.وصفي التل ,عمان",),
                      
                          ]),
                  ),
                ),
            
              ),
            ),
     
           // //satus details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Mycontainer(500,
            
             Padding(
               padding: const EdgeInsets.only(right:90.0),
               child: Flexible(
                      child: FixedTimeline.tileBuilder(
                        direction: Axis.vertical,
                        builder: TimelineTileBuilder.connectedFromStyle(
                           
                          contentsAlign: ContentsAlign.basic,
                          connectionDirection: ConnectionDirection.before,
                          connectorStyleBuilder: (context, index) {
                          
                            return (index == 1)
                                ? ConnectorStyle.dashedLine
                                : ConnectorStyle.dashedLine;
                          },
                          
                          contentsBuilder: (context, index) => 
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                                Text('Status Name $index'), // Replace with your status name
                                const Text('Time'), // Replace with your time
                            ],
                                               ),
                          ),
                        //  const Text('Contents',style: TextStyle(fontSize: 10),),
                          indicatorStyleBuilder: (context, index) =>
                             
                              IndicatorStyle.dot,
                  
                          itemExtent: 80.0,
                          itemCount: 6,
                        ),
                      ),
                    ),
             ),
            
          
            ),
          ),
    
          ],
             ),
       ),
        ) ;
         
}

  }




Widget RowInfo(title,value){
  return
  Padding(
    padding: const EdgeInsets.all(2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      //title

       Text(
        value,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          color: AppColor.secondary,
          fontFamily: 'DroidArabicKufi',
          fontSize:10, 
        ),
        ),
      Text(
        title,
        style: const TextStyle(
          color: AppColor.main,
          fontFamily: 'DroidArabicKufi',
          fontSize:13, 
        ),
        textDirection: TextDirection.rtl,
        ),
    
      //value
    
     
    ],),
  );
}







