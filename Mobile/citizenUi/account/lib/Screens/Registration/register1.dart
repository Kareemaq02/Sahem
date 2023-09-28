import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/signup_request.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:account/Validation/validations.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/Widgets/CheckBoxes/CheckBox.dart';
import 'package:account/Screens/Registration/register.dart';
import 'package:account/Screens/Registration/register2.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:account/Widgets/HelperWidegts/fieldContainer.dart';

// ignore_for_file: prefer_const_constructors, constant_identifier_names, unused_element, depend_on_referenced_packages, non_constant_identifier_names, library_private_types_in_public_api, unnecessary_null_comparison

bool idNumber = true;
late String _nationalNumber;
late String _idNumber;
late String _registrationNumber1;
late String _registrationNumber2;
Validation _validation = Validation();

TextEditingController nationalNumController = TextEditingController();
TextEditingController iDNumbberController = TextEditingController();
TextEditingController regNumberController = TextEditingController();

GlobalKey nationalNumKey = GlobalKey();

bool _validate1 = false;
List<String> dropdownItems = [
  'Select Here',
  'National ID Number',
  'registration Number'
];
String dropdownValue = dropdownItems.first;

class XDRegister1 extends StatefulWidget {
  const XDRegister1({
    Key? key,
  }) : super(key: key);
  @override
  _XDRegister1State createState() => _XDRegister1State();
}

class _XDRegister1State extends State<XDRegister1> {
  UserSignup user = UserSignup();
  TextEditingController passwordController4 = TextEditingController();
  TextEditingController usernameContoller4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffffffff),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    'assets/icons/logo_sahem.png',
                    scale: 3.5,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FieldContainer(
                  context,
                  'رقم الوطني',
                  false,
                  Icons.account_circle_rounded,
                  nationalNumController,
                  TextInputType.number,
                  null,
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CheckBoxNew(
                      text: 'رقم الهوية',
                      isChecked: idNumber == true,
                      onChanged: () {
                        setState(() {
                          idNumber = true;
                        });
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).padding.left + 7,
                    ),
                    CheckBoxNew(
                      text: " رقم القيد",
                      isChecked: idNumber == false,
                      onChanged: () {
                        setState(() {
                          idNumber = false;
                        });
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).padding.left + 5,
                    ),
                    text(
                      "مستند التحقق",
                      AppColor.main,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                FieldContainer(
                  context,
                  !idNumber ? 'رقم القيد' : 'رقم الهوية',
                  false,
                  Icons.note_rounded,
                  !idNumber ? regNumberController : iDNumbberController,
                  !idNumber ? TextInputType.number : TextInputType.text,
                  null,
                ),
                const SizedBox(
                  height: 10,
                ),
                FieldContainer(
                  context,
                  ' اسم المستخدم ',
                  false,
                  Icons.account_circle_rounded,
                  usernameContoller4,
                  TextInputType.text,
                  null,
                ),
                const SizedBox(
                  height: 10,
                ),
                FieldContainer(
                  context,
                  '  كلمة السر',
                  true,
                  Icons.lock_outline,
                  passwordController4,
                  TextInputType.text,
                  null,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 10,
                ),
                BottonContainer("استمرار", Colors.white, AppColor.main, 240,
                    context, true, "", () {
                  user.signup(
                      usernameContoller4.text,
                      PhoneController.text,
                      passwordController4.text,
                      FnameController.text,
                      LnameController.text,
                      EmailController.text,
                      nationalNumController.text,
                      passportNumController.text,
                      regNumberController.text,
                      iDNumbberController.text,
                      context);
                }),
                SizedBox(
                  height: 15,
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
        ));
  }
}
