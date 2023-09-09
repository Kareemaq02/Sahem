import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:account/Validation/validations.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/Widgets/CheckBoxes/CheckBox.dart';
import 'package:account/Screens/Registration/register1.dart';
import 'package:account/Screens/Registration/register2.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:account/Widgets/HelperWidegts/fieldContainer.dart';

// ignore_for_file: constant_identifier_names, unused_element, non_constant_identifier_names, camel_case_types, library_private_types_in_public_api

enum nationalitySelection { Jordanian, forign }

var selectedNationality = nationalitySelection.forign;
Validation _validation = Validation();

TextEditingController FnameController = TextEditingController();
TextEditingController LnameController = TextEditingController();
TextEditingController PhoneController = TextEditingController();
TextEditingController EmailController = TextEditingController();
Validation a = Validation();
class XDRegister extends StatefulWidget {
  const XDRegister({
    Key? key,
  }) : super(key: key);
  @override
  _XDRegisterState createState() => _XDRegisterState();
}

class _XDRegisterState extends State<XDRegister> {
  bool isJordanian = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffffffff),
        body: SafeArea(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 55,
                        height: 100,
                        decoration: const BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Logobrand',
                        style: TextStyle(
                            fontWeight: FontWeight.w100, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FieldContainer(
                    context,
                    'اسم الأول',
                    false,
                    Icons.account_circle,
                    FnameController,
                    TextInputType.text, 
                    null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FieldContainer(
                    context,
                    'الاسم الأخير',
                    false,
                    Icons.account_circle,
                    LnameController,
                    TextInputType.text, 
                    null, 
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FieldContainer(
                    context,
                    'البريد الالكتروني',
                    false,
                    Icons.email,
                    EmailController,
                    //a.validateEmail,
                    TextInputType.emailAddress, 
                    null, 
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FieldContainer(
                    context,
                    'رقم الهاتف',
                    false,
                    Icons.phone_android,
                    EmailController,
                    //a.validateEmail,
                    TextInputType.number, 
                    null, 
                  ),
                  
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).padding.left + 50,
                      ),
                      CheckBoxNew(
                        text: "لا",
                        isChecked: isJordanian == false,
                        onChanged: () {
                          setState(() {
                            isJordanian = false;
                          });
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).padding.left + 7,
                      ),
                      CheckBoxNew(
                        text: "نعم",
                        isChecked: isJordanian == true,
                        onChanged: () {
                          setState(() {
                            isJordanian = true;
                          });
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).padding.left + 40,
                      ),
                      const Text(
                        "هل أنت أردني؟",
                        style: TextStyle(
                            color: AppColor.main,
                            fontFamily: 'DroidArabicKufi',
                            fontSize: 11),
                      )
                    ],
                  ),


                  const SizedBox(
                    height: 10,
                  ),

                  BottonContainer(
                      "استمرار",
                      Colors.white,
                      AppColor.main,
                      240,
                      context,
                      false,
                     
                      isJordanian == true
                              ? XDRegister1()
                              : XDRegister2(),
                      () {}),

                  const SizedBox(
                    height: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(" تسجيل الدخول ", AppColor.main),
                      TextButton(
                        child: text(" لديك حساب؟", AppColor.secondary),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const XDLogin()),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ));
  }
}