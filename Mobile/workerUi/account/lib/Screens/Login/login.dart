import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Widgets/CheckBoxes/CheckBox.dart';
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
  bool remeberMe = false;
  void dispose() {
    usernameController.clear();
    passwordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///final screenWidth = MediaQuery.of(context).size.width;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    'assets/icons/logo_sahem.png',
                    scale: 3,
                  ),
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
                    SizedBox(
                      width: MediaQuery.of(context).padding.left +
                          screenSize.width * 0.5,
                    ),
                    const SizedBox(
                      width: 2.5,
                    ),
                    CheckBoxNew(
                      text: "تذكر تسجيل الدخول",
                      isChecked: remeberMe,
                      onChanged: () {
                        setState(() {
                          remeberMe = !remeberMe;
                        });
                      },
                    ),
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
                    if (remeberMe == true) {
                      TextInput.finishAutofillContext();
                    }
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
