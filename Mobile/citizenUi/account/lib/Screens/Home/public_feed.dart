// ignore_for_file: depend_on_referenced_packages, constant_identifier_names, unused_element, library_private_types_in_public_api, prefer_typing_uninitialized_variables, use_build_context_synchronously, duplicate_ignore
import 'package:account/API/get_complaints_ByLocation.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/appBar.dart';
import 'package:account/Widgets/bottomNavBar.dart';
import 'package:account/Widgets/complaintCard.dart';
import 'package:flutter/material.dart';
import '../../API/view_complaint_request.dart';



class XDPublicFeed1 extends StatefulWidget {
  const XDPublicFeed1({Key? key}) : super(key: key);

  @override
  _XDPublicFeed1State createState() => _XDPublicFeed1State();
}

class _XDPublicFeed1State extends State<XDPublicFeed1> {
  
  
  late List<ComplaintModel> complaints;
  late var address;

  @override
  void initState() {

   super.initState();
   
  
    
   
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor:AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton:const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:  BottomNavBar1(0),
      
     appBar:myAppBar(context),
      body:Column(children: [
   

         //complaint Post
        Expanded(
          child: RefreshIndicator(
            displacement: 100,
           backgroundColor: AppColor.background,
           color: AppColor.main,
           strokeWidth: 3,
           triggerMode: RefreshIndicatorTriggerMode.onEdge,
            onRefresh:()async{},
            child: FutureBuilder<List<dynamic>>(
            future: getComplaintsByLocation(31.961899172907753, 35.86508730906701),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
            var data = snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (BuildContext context, int index) {
             
             
                return ComplaintCard(context,
                intComplaintId:data[index]['intComplaintId'].toString(),
                strStatus:data[index]['strStatus'].toString(),
                strUserName:data[index]['strUserName'].toString(),
                dtmDateCreated: data[index]['dtmDateCreated'].toString(),
                 intVotersCount: data[index]['intVotersCount'],
                 strComplaintTypeEn: data[index]['strComplaintTypeAr'].toString(),
                 strComment: data[index]['StrComment'].toString(),
                address: " ش. وصفي التل,عمّان"
                
                
                );
              
              },
            ); 
                } else {
            return const Text('No complaints found'); 
                }
              } else {
                    return const Center(child: CircularProgressIndicator());
              }
            },
            ),
          ),
        ),
      ])     
    );
  }
}

