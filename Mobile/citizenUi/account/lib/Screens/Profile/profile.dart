import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/API/user_info_request.dart';
import 'package:account/Screens/Profile/logout.dart';
import 'package:account/Screens/Profile/dataBox.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<UserInfoModel> _userInfo = [];
  getUserInfo user = getUserInfo();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo("520");
  }

  Future<void> _fetchUserInfo(String userId) async {
    try {
      List<UserInfoModel> userInfo = await user.getUserInfoById(userId);
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
      return Center(child: CircularProgressIndicator());
    }
    UserInfoModel userInfo = _userInfo[0];

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton: const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar1(3),
      appBar: myAppBar(context, "الإعدادات", false, 170),
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
              InfoBox('${userInfo.strFirstName!} ${userInfo.strLastName!}'),
              SizedBox(height: screenSize.height * 0.01),
              DataBox(
                  'أسم المستخدم',  userInfo.strUsername!, ),
              DataBox("البريد الالكتروني", userInfo.strUsername!,
                  ),
              DataBox(
                  "رقم الهاتف",  userInfo.strPhoneNumber!, ),
              DataBox(
                "كلمة المرور",
                
                "********",
                
              ),
             // DataBox("استلام الاشعارات", switchV, "غير مفعل",),
              logoutBox(context),
            ],
          ),
        ),
      ),
    );
  }
}
