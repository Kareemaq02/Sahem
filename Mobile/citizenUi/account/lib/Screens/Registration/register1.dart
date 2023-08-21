// ignore_for_file: prefer_const_constructors, constant_identifier_names, unused_element, depend_on_referenced_packages, non_constant_identifier_names, library_private_types_in_public_api, unnecessary_null_comparison

import 'package:account/Repository/color.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:account/Screens/Registration/register.dart';
import 'package:account/Validation/validations.dart';
import 'package:account/Widgets/bottonContainer.dart';
import 'package:account/Widgets/checkBox.dart';
import 'package:account/Widgets/fieldContainer.dart';
import 'package:account/Widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/services.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Repository/language_constants.dart';


String IdField="National number";
late String _nationalNumber;
late String _idNumber;
late String _registrationNumber1;
late String _registrationNumber2;
Validation _validation=Validation();



GlobalKey nationalNumKey = GlobalKey();


bool _validate1 = false;
List<String> dropdownItems = ['Select Here','National ID Number','registration Number'];
String dropdownValue = dropdownItems.first;


class XDRegister1 extends StatefulWidget {
  const XDRegister1({
    Key? key,
  }) : super(key: key);
       @override
  _XDRegister1State createState() => _XDRegister1State();
}

class _XDRegister1State extends State<XDRegister1> {


TextEditingController nationalNumController = TextEditingController();
TextEditingController iDNumbberController = TextEditingController();
TextEditingController regNumberController = TextEditingController();
TextEditingController passwordController4= TextEditingController();
TextEditingController usernameContoller4= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      body:Center(
       
        child: Column(
            
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 55,height: 100,decoration: BoxDecoration(color: Colors.grey,shape: BoxShape.circle),),
                SizedBox(width: 10,),
                const Text('Logobrand',style: TextStyle(fontWeight: FontWeight.w100,fontSize: 20),),
              ],
            ),
            const SizedBox(height: 30,),
        FieldContainer(context,' الرقم الوطني' ,false,Icons.account_circle,nationalNumController
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 7,),
         Row(
       mainAxisAlignment: MainAxisAlignment.center,
        children: [
       
          checkboxWidget('رقم الهوية',context),
          SizedBox(width: MediaQuery.of(context).padding.left + 7,),
          checkboxWidget("رقم القيد",context),
         SizedBox(width: MediaQuery.of(context).padding.left + 35,),
          text("مستند التحقق",AppColor.main,),
       
        
       
        
        // SizedBox(width: 2.5,),
        
  //        Checkbox(
  //         focusColor: AppColor.main,
  //         side: BorderSide(width: 1,color: AppColor.main,),   
  //         onChanged: (value) {
  //         setState(() {
  //         isChecked = value!;
  //         });
  //   },
  //   value: isChecked, 
  // ),
       ],),
           const SizedBox(height: 10,),
         FieldContainer(context,'رقم القيد' ,false,Icons.note_rounded,regNumberController
        ),
            const SizedBox(height: 10,),
        FieldContainer(context,' اسم المستخدم ' ,false,Icons.account_circle_rounded,usernameContoller4
        ),
           const SizedBox(height: 10,),
         FieldContainer( context,'  كلمة السر' ,true,Icons.lock_outline,passwordController4
        ),
           const SizedBox(height: 15,),
      
        SizedBox(height: 10,),
       
       BottonContainer("استمرار",Colors.white, AppColor.main,240,context,false,XDLogin(),null),
       SizedBox(height: 15,),
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
         children: [
           text(" تسجيل الدخول " ,AppColor.main),
           TextButton(child: text(" لديك حساب؟",AppColor.secondary),onPressed:() =>  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const XDLogin ()),
            ),),
         ],
       ),
      ]
      ), 
    ));
  }
}