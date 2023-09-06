import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:account/Validation/validations.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/Widgets/HelperWidegts/checkBox.dart';
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
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
Validation a = Validation();

// bool jordanian = false;
// bool forign = false;

class XDRegister extends StatefulWidget {
  const XDRegister({
    Key? key,
  }) : super(key: key);
  @override
  _XDRegisterState createState() => _XDRegisterState();
}

class _XDRegisterState extends State<XDRegister> {
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
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: FieldContainer(
                      context,
                      'اسم الأول',
                      false,
                      Icons.account_circle,
                      FnameController,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم الأول';
                        }
                        return null; // Return null for no error
                      },
                      TextInputType.text, // For text input
                      null, // No maximum length
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _formKey1,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: FieldContainer(
                      context,
                      'الاسم الأخير',
                      false,
                      Icons.account_circle,
                      LnameController,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم الأخير';
                        }
                        return null; // Return null for no error
                      },
                      TextInputType.text, // For text input
                      null, // No maximum length
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey2,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: FieldContainer(
                      context,
                      'البريد الالكتروني',
                      false,
                      Icons.email,
                      EmailController,
                      a.validateEmail,
                      TextInputType.emailAddress, // For email input
                      null, // No maximum length
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey3,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: FieldContainer(
                      context,
                      'رقم الهاتف',
                      false,
                      Icons.phone,
                      PhoneController,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        } else if (value.length > 10) {
                          return 'يجب أن يكون رقم الهاتف أقل من 10 أرقام';
                        }
                        return null; // Return null for no error
                      },
                      TextInputType.phone, // For phone input
                      10, // Maximum length of 10 characters
                    ),
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
                      checkboxWidget("لا", context),
                      SizedBox(
                        width: MediaQuery.of(context).padding.left + 7,
                      ),
                      checkboxWidget('نعم', context),
                      SizedBox(
                        width: MediaQuery.of(context).padding.left + 80,
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
                      (FnameController != null &&
                              LnameController != null &&
                              PhoneController != null &&
                              EmailController != null)
                          ? (selectedNationality ==
                                  nationalitySelection.Jordanian
                              ? XDRegister1()
                              : XDRegister1())
                          : XDRegister1(),
                      null),

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