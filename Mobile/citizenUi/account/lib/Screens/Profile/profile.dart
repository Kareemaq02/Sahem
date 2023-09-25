import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/API/user_info_request.dart';
import 'package:account/Screens/Profile/logout.dart';
import 'package:account/Screens/Profile/dataBox.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Screens/Profile/switchWidget.dart';
// ignore_for_file: unused_import

// ignore_for_file: avoid_print, library_private_types_in_public_api


class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<UserInfoModel> _userInfo = [];
  getUserInfo user = getUserInfo();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      List<UserInfoModel> userInfo = await user.getUserInfoById();
      setState(() {
        _userInfo = userInfo;
        print(_userInfo);
      });
    } catch (error) {
      print("Error fetching user info: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (_userInfo.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    UserInfoModel userInfo = _userInfo[0];

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      // floatingActionButton: const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar1(3),
      appBar: myAppBar(context, "الإعدادات", false, screenSize.width * 0.55),
      body: Padding(
        padding: EdgeInsets.only(
          top: screenSize.height * 0.01,
          bottom: screenSize.height * 0.01,
          left: screenSize.width * 0.02,
          right: screenSize.width * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InfoBox(  userInfo.strFirstNameAr != null
                      ?
                '${userInfo.strFirstNameAr!} ${userInfo.strLastNameAr!}'
                      : 'أحمد محمد',
                  userInfo.strNationalId),
              SizedBox(height: screenSize.height * 0.01),
              DataBox(
                  'أسم المستخدم',
                  userInfo.strFirstNameAr != null
                      ? '${userInfo.strFirstNameAr!} ${userInfo.strLastNameAr!}'
                      : 'أحمد محمد'),
              DataBox(
                "البريد الالكتروني",
                userInfo.strUsername!,
              ),
              DataBox(
                "رقم الهاتف",
                userInfo.strPhoneNumber!,
              ),
              DataBox(
                "كلمة المرور",
                "********",
              ),
              DataBox("استلام الاشعارات", "غير مفعل", false),
              SizedBox(height: screenSize.height * 0.02),
              
              logoutBox(context),
            ],
          ),
        ),
      ),
    );
  }
}
