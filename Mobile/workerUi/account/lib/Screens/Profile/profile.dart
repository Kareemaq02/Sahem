import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Screens/Profile/logout.dart';
import 'package:account/Screens/Profile/dataBox.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Screens/Profile/textButton.dart';
import 'package:account/Screens/Profile/switchWidget.dart';
import 'package:account/API/ProfileAPI/user_info_request%20copy.dart';



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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (_userInfo.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    UserInfoModel userInfo = _userInfo[0];

    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar1(3),
      appBar: myAppBar(context, "الإعدادات", false, screenHeight * 0.1),
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
                child: InfoBox('${userInfo.strFirstName!} ${userInfo.strLastName!}'),
              ),
              SizedBox(height: screenHeight * 0.02),
              DataBox(
                'أسم المستخدم',
                textButtn,
                userInfo.strUsername!,
              ),
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
              DataBox("اللغة", toggleLang, "العربية"),
              SizedBox(height: screenHeight * 0.02),
              logoutBox(context),
            ],
          ),
        ),
      ),
    );
  }
}

List<bool> _isSelected = [true, false];

Widget toggleLang() {
  return SizedBox(
    //width: 80, // Set the desired width
    height: 25, // Set the desired height
    child: ToggleButtons(
      renderBorder: true,
      borderColor: AppColor.main, // Make sure AppColor.main is defined
      borderRadius: BorderRadius.circular(20),
      children: <Widget>[
        Text('En',style: TextStyle(fontSize: 10),),
        Text('ع',style: TextStyle(fontSize: 10),),
      ],
      isSelected: _isSelected,
      color: Colors.grey,
      selectedColor: Colors.white,
      fillColor: AppColor.main,
      onPressed: (int index) {
        // setState(() {
        //   _isSelected[index] = !_isSelected[index];
        // });
      },
    ),
  );
}

