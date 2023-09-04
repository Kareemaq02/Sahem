import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timelines/timelines.dart';
import 'package:animations/animations.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/Widgets/HelperWidegts/myContainer.dart';
import 'package:account/API/view_complaint_request.dart' as api;
import 'package:account/Screens/View%20complaints/complaints_details.dart';
// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, duplicate_ignore, unused_element, constant_identifier_names, library_private_types_in_public_api, avoid_print


 bool reminder=false;

 
class XDComplaintsList extends StatefulWidget {
  const XDComplaintsList({Key? key}) : super(key: key);

  @override
  _XDComplaintsListState createState() => _XDComplaintsListState();
}

class _XDComplaintsListState extends State<XDComplaintsList> {
  late List<api.ComplaintModel> complaints=[];
 

  @override
  void initState() {
   
    fetchComplaints();
    super.initState();
   
  }
 //String token23='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFidXJ1bW1hbm4iLCJmaXJzdE5hbWUiOiJydWJhIiwibGFzdE5hbWUiOiJhYnVydW1tYW4iLCJwaG9uZU51bWJlciI6IjA3OTg5ODk5OTkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2ODg4ODc4MTEsImV4cCI6MTY5MTQ3OTgxMSwiaWF0IjoxNjg4ODg3ODExfQ.nK7fewOq3b9HCXNwJLAWd3Q9Xx8JGP-8-KOY_EPomxk';
Future<List<dynamic>> fetchComplaints() async {
  final response = await http.get(Uri.parse("https://10.0.2.2:5000/api/complaints/user"),
   headers: {
          'Authorization': 'Bearer $token2',
        }
  );

  if (response.statusCode == 200) {

    print("ok");
    // print(token2);
   // print(jsonDecode(response.body.toString()));
    return jsonDecode(response.body.toString());
  } else {
    throw Exception('Failed to fetch complaints');
  }
}
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton:const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavBar1(2),
      appBar:myAppBar(context,'بلاغاتي',true,130),

      body: Column(
       children: [
         Expanded(
       
           child: FutureBuilder(
             future: fetchComplaints(),
             builder: (context, snapshot) {
             
              
                // comment: data![index]['strComment'].toString(),type: data[index]['strComplaintTypeEn'].toString(),status: data[index]['strStatus'].toString(),date: data[index]['dtmDateCreated'].toString(), id: data[index]['intComplaintId'].toString(),
            
               if (snapshot.hasData) {
                var data = snapshot.data as List<dynamic>?;
                 return ListView.builder(
                    itemCount: data != null ? data.length : 0,
                   itemBuilder: (context, index) {
                     return 
                       Column(
                         children: [
                     
                     //ComaplaintContainer(),
                     ReusableRow( comment: data![index]['strComment'].toString(),type: data[index]['strComplaintTypeAr'].toString(),status: data[index]['strStatus'].toString(),date: data[index]['dtmDateCreated'].toString(), id: data[index]['intComplaintId'].toString(),),
                    // ReusableRow( value: data[index]['strStatus'].toString(),),
                          
                         ],
                       
                     );
                   },
                 );
               } else {
                 return Text("No data available");
               }
             },
           ),
         ),
       ],));
  }


  Widget ComaplaintContainer(){
  return 
   Padding(
          padding: const EdgeInsets.all(8.0),
          child: Mycontainer(160,
          
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const SizedBox(height: 10,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     IgnorePointer(
                      ignoring: reminder,
                      child: BottonContainer('تذكير', Colors.grey, reminder ? AppColor.main : Colors.grey, 60,{})),
                     const SizedBox(width: 10,),
                     BottonContainer('معاينة', Colors.grey,
                      AppColor.main, 60,{}),
                     const Spacer(),
                     text("مخلفات اعمال بناء",AppColor.secondary),
                 ],),
                 const Padding(
                   padding: EdgeInsets.only(left: 250.0),
                   child: Text("قبل 5 ساعات",style: TextStyle(color:Colors.grey),textAlign: TextAlign.end,textDirection: TextDirection.ltr,),
                 ),
                   Flexible(
                    child: FixedTimeline.tileBuilder(
                      direction: Axis.horizontal,
                      builder: TimelineTileBuilder.connectedFromStyle(
                         
                        contentsAlign: ContentsAlign.alternating,
                        connectionDirection: ConnectionDirection.before,
                        connectorStyleBuilder: (context, index) {
                        
                          return (index == 1)
                              ? ConnectorStyle.dashedLine
                              : ConnectorStyle.dashedLine;
                        },
                        
                        contentsBuilder: (context, index) => const Text('Contents',style: TextStyle(fontSize: 10),),
                        indicatorStyleBuilder: (context, index) =>
                           
                            IndicatorStyle.dot,
                
                        itemExtent: 50.0,
                        itemCount: 6,
                      ),
                    ),
                  ),
                 
                 Padding(
                   padding: const EdgeInsets.only(right:220.0),
                   child: text("ش ,وصفي التل , عمان", AppColor.secondary),
                 ),
                 
                ]),
            ),
          ),
  );
}
  



}
Widget BottonContainer(String text,textColor,Color boxColor,double width,whatToDo)
{
  return   Container(
              height:22 ,
              //width: ,
              decoration:
               BoxDecoration(
                borderRadius:const BorderRadius.all(Radius.circular(10)),
              border:Border.all(
              color: textColor,
              width: 1.3,
              style: BorderStyle.solid
              ),
       ),    
              child: 
              ElevatedButton(
                style: 
                ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(boxColor),
                ),
                onPressed:(){
                whatToDo();
                },
                child: 
                 Text(
                  text,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color:Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500                 
                  ),
                ),
                 ),
                 
            );


            
}



    


class ReusableRow extends StatelessWidget {
  final String comment;
  final String type;
  final String status;
  final String date;
  final String id;
 

   const ReusableRow({
    Key? key,
    required this.comment,
    required this.status,
    required this.date,
    required this.type, required this.id, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DateTime dateTime = DateTime.parse(date);
    // String time =
    //     '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    // String period = dateTime.hour < 12 ? 'am' : 'pm';

    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: Colors.transparent,
      closedBuilder: (context, openContainer) {
        return  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Mycontainer(160,
          
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const SizedBox(height: 10,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     IgnorePointer(
                      ignoring: reminder,
                      child: BottonContainer('تذكير', Colors.grey, reminder ? AppColor.main : Colors.grey, 60,{})),
                     const SizedBox(width: 10,),
                     BottonContainer('معاينة', Colors.grey,
                      AppColor.main, 60,{}),
                     const Spacer(),
                     text(type,AppColor.textTitle),
                 ],),
                  Padding(
                   padding: EdgeInsets.only(left: 200.0),
                   child: text("قبل 5 ساعات ",AppColor.textBlue)
                 ),
                 SizedBox(height: 15,),
                   Flexible(
                    child: FixedTimeline.tileBuilder(
                      direction: Axis.horizontal,
                      builder: TimelineTileBuilder.connectedFromStyle(
                         
                        contentsAlign: ContentsAlign.alternating,
                        connectionDirection: ConnectionDirection.before,
                        connectorStyleBuilder: (context, index) {
                        
                          return (index == 1)
                              ? ConnectorStyle.dashedLine
                              : ConnectorStyle.dashedLine;
                        },
                        
                        contentsBuilder: (context, index) => const Text('Contents',style: TextStyle(fontSize: 10),),
                        indicatorStyleBuilder: (context, index) =>
                           
                            IndicatorStyle.dot,
                
                        itemExtent: 45.0,
                        itemCount: 6,
                      ),
                    ),
                  ),
                 
                 Padding(
                   padding: const EdgeInsets.only(right:175.0),
                   child: text("ش ,وصفي التل , عمان", AppColor.secondary),
                 ),
                 
                ]),
            ),
          ),
  );
      },
    openBuilder: (context, closeContainer) {
  api.getUserComplaint a = api.getUserComplaint();
  Future<List<api.ComplaintModel>> complaintFuture = a.getComplaintById(id);
  
  return FutureBuilder<List<api.ComplaintModel>>(
    future: complaintFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return text('Error: ${snapshot.error}',AppColor.main);
      } else if (snapshot.hasData) {
        List<api.ComplaintModel> complaints = snapshot.data!;
        return ComplaintDetailsScreen(
          complaints: complaints,
        );
      } else {
        return text('Error: ${snapshot.error}',AppColor.main);
      }
    },
  );
},

    );
}}

      


