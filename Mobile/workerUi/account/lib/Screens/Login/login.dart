import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Widgets/HelperWidgets/text.dart';
import 'package:account/Widgets/HelperWidgets/checkBox.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:account/Widgets/HelperWidgets/fieldContainer.dart';

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
UserLogin user = UserLogin();

class XDLogin extends StatefulWidget {
  const XDLogin({Key? key}) : super(key: key);
  @override
  _XDLoginState createState() => _XDLoginState();
}

class _XDLoginState extends State<XDLogin> {

  void dispose() {
    usernameController.clear();
    passwordController.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
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
                          fontFamily: 'DroidArabicKufi',
                          fontWeight: FontWeight.w100,
                          fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                FieldContainer(context, 'اسم المستخدم', false,
                    Icons.account_circle, usernameController),
                const SizedBox(
                  height: 20,
                ),
                FieldContainer(context, ' كلمة السر', true, Icons.lock_outline,
                    passwordController),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 58.0),
                      child: text(
                        "نسيت كلمة السر؟",
                        AppColor.main,
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).padding.left +
                            screenWidth * 0.2),

                    text(
                      "تذكر تسجيل الدخول",
                      AppColor.main,
                    ),
                    const SizedBox(
                      width: 2.5,
                    ),
                    checkboxWidget("", context),
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
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                BottonContainer(
                  "الدخول",
                  Colors.white,
                  AppColor.main,
                  240,
                  context,
                  true,
                  null,
                  () {
                    user.login(usernameController.text, passwordController.text,
                        context);
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                //const SizedBox(height: 10,),
              ]),
        ));
  }
}

navigatorCostum(BuildContext context, PageName) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PageName),
  );
}
