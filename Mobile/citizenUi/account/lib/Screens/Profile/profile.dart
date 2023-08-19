import 'package:account/API/user_info_request.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/Profile/dataBox.dart';
import 'package:account/Screens/Profile/logout.dart';
import 'package:account/Screens/Profile/switchWidget.dart';
import 'package:account/Screens/Profile/textButton.dart';
import 'package:account/Widgets/appBar.dart';
import 'package:account/Widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';


 bool isChecked = false;
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


     List<UserInfoModel> _userInfo=[];
  getUserInfo user=getUserInfo();

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
 if (_userInfo.isEmpty) {

    return const Center(child: CircularProgressIndicator());}
      UserInfoModel userInfo = _userInfo[0];

   
    return  Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton:const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:BottomNavBar1(3),
       appBar:myAppBar(context,"الإعدادات",false,170),
      body: Padding(
        padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                
              Padding(
                padding: const EdgeInsets.only(right:8.0,left: 8.0),
                child: InfoBox( '${userInfo.strFirstName!} ${userInfo.strLastName!}',),
              ),
              SizedBox(height: 10,),
              DataBox('أسم المستخدم',textButtn,userInfo.strUsername!,),
              DataBox("البريد الالكتروني",textButtn,userInfo.strUsername!,),
              DataBox("رقم الهاتف",textButtn,userInfo.strPhoneNumber!,),
              DataBox("كلمة المرور",textButtn,"********"),
              DataBox("استلام الاشعارات",switchV,"غير مفعل"),
              DataBox("اللغة",toggleLang,"العربية"),
             SizedBox(height: 10,),
             logoutBox(context),
              ],),
              
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

