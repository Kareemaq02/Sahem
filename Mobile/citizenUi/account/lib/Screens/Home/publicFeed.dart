import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/Filter/filterType.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/Widgets/Filter/filterStatus.dart';
import 'package:account/API/get_complaints_with_filter.dart';
import 'package:account/Widgets/HelperWidegts/complaintCard.dart';
// ignore_for_file: file_names, empty_catches


Position? currentPosition;
// ignore_for_file: depend_on_referenced_packages, constant_identifier_names, unused_element, library_private_types_in_public_api, prefer_typing_uninitialized_variables, use_build_context_synchronously, duplicate_ignore
class XDPublicFeed1 extends StatefulWidget {
  const XDPublicFeed1({Key? key}) : super(key: key);

  @override
  _XDPublicFeed1State createState() => _XDPublicFeed1State();
}

class _XDPublicFeed1State extends State<XDPublicFeed1> {
  late var address;
  bool _isDisposed = false;
  double lat = 0.0;
  double lng = 0.0;

  @override
  void initState() {
    _getCurrentPosition();
    selectedTypes1.clear();
    selectedStatus.clear();
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('تم تعطيل خدمة الموقع الحالي. الرجاء تفعيل الخدمة')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم رفض أذونات الموقع')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم رفض أذونات الموقع بشكل دائم.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission || _isDisposed) return;
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!_isDisposed) {
        setState(() => currentPosition = position);
      }
    } catch (e) {}
  }

 
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton: const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar1(3),
      appBar: myAppBar(context, 'البلاغات المعلنة', true, screenSize.width*0.32),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: RefreshIndicator(
              displacement: 100,
              backgroundColor: AppColor.background,
              color: AppColor.main,
              strokeWidth: 3,
              //triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                getFilteredComplaints(
                  selectedStatus,
                  selectedTypes1,
                  currentPosition?.latitude ?? 0.0,
                  currentPosition?.longitude ?? 0.0,
                );
                setState(() {});
              },
              child: FutureBuilder<List<dynamic>>(
                future: getFilteredComplaints(
                  selectedStatus,
                  selectedTypes1,
                  currentPosition?.latitude ?? 0.0,
                  currentPosition?.longitude ?? 0.0,
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      return ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          lat = data[index]['latLng']["decLat"];
                          lng = data[index]['latLng']["decLng"];
                          return ComplaintCardPublicForm(
                              intComplaintId: data[index]['intComplaintId'],
                            statusID: data[index]['intStatusId'],
                              strUserName1:
                                data[index]['strFirstNameAr'].toString(),
                              strUserName2:
                                data[index]['strLastNameAr'].toString(),
                              dtmDateCreated:
                                  data[index]['dtmDateCreated'].toString(),
                              intVotersCount: data[index]['intVotersCount'],
                              strComplaintTypeEn:
                                  data[index]['strComplaintTypeAr'].toString(),
                              strComment: data[index]['strComment'].toString(),
                              isVoted: data[index]['intVoted'],
                              isWatched: data[index]['blnIsOnWatchList'],
                            lat: data[index]['latLng']["decLat"],
                            lng: data[index]['latLng']["decLng"],
                            i: index,
                          );
                        },
                      );
                    } else {
                      return Center(
                          child: text('لا يوجد بلاغات قريبة من هذه المنطقة',
                              AppColor.main));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
