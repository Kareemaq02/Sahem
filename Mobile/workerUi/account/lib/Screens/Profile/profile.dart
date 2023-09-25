import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Screens/Profile/logout.dart';
import 'package:account/Screens/Profile/dataBox.dart';
import 'package:account/Widgets/Bars/NavBarAdmin.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Screens/Profile/textButton.dart';
import 'package:account/Screens/Profile/switchWidget.dart';
import 'package:account/API/ProfileAPI/user_info_request%20copy.dart';
// ignore_for_file: avoid_print
// ignore_for_file: library_private_types_in_public_api

class Profile extends StatefulWidget {
  const Profile({super.key});

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
      });
    } catch (error) {
      print("Error fetching user info: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (_userInfo.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    UserInfoModel userInfo = _userInfo[0];

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: userIsAdmin() ? NavBarAdmin(0) : BottomNavBar1(0),
      appBar: myAppBar(context, "الإعدادات", false, screenWidth * 0.6),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                ),
                child: InfoBox(
                    userInfo.strFirstNameAr != null
                        ? '${userInfo.strFirstNameAr!} ${userInfo.strLastNameAr!}'
                        : "أحمد النعيمات",
                    userInfo.strNationalId),
              ),
              SizedBox(height: screenHeight * 0.02),
              DataBox(
                  'أسم المستخدم',
                  textButtn,
                  userInfo.strFirstNameAr != null
                      ? '${userInfo.strFirstNameAr!} ${userInfo.strLastNameAr!}'
                      : "أحمد النعيمات"),
              DataBox(
                "البريد الالكتروني",
                textButtn,
                userInfo.strUsername!,
              ),
              DataBox(
                "رقم الهاتف",
                textButtn,
                userInfo.strPhoneNumber!,
              ),
              DataBox("كلمة المرور", textButtn, "********"),
              DataBox("استلام الاشعارات", switchV, "غير مفعل"),
              SizedBox(height: screenHeight * 0.02),
              logoutBox(context),
            ],
          ),
        ),
      ),
    );
  }
}
