import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Validation/validations.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/Widgets/CheckBoxes/CheckBox.dart';
import 'package:account/Screens/Registration/register.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:account/Widgets/HelperWidegts/fieldContainer.dart';
// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
UserLogin user = UserLogin();
Validation a = Validation();
bool remeberMe = false;

class XDLogin extends StatefulWidget {
  const XDLogin({Key? key}) : super(key: key);

  @override
  _XDLoginState createState() => _XDLoginState();
}

class _XDLoginState extends State<XDLogin> {

  

  @override
  Widget build(BuildContext context) {
      final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/icons/logo_sahem.webp',
              scale: 3.5,
            ),
            const SizedBox(
              height: 30,
            ),
            FieldContainer(
                context,
                'اسم المستخدم',
                false,
                Icons.account_circle,
                usernameController,
                //  a.inputValidate,
                TextInputType.text,
                null,
                remeberMe),
            const SizedBox(
              height: 20,
            ),
            FieldContainer(
              context,
              ' كلمة السر',
              true,
              Icons.lock_outline,
              passwordController,
              //a.inputValidate,
              TextInputType.text,
              null,
              remeberMe,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).padding.left + screenSize.width*0.5 ,
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
              MediaQuery.of(context).size.width * 0.7,
              context,
              true,
              null,
              () {
                if (remeberMe == true) {
                  TextInput.finishAutofillContext();
                }
                user.login(
                  usernameController.text,
                  passwordController.text,
                  context,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text(" تسجيل حساب جديد ", AppColor.main),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const XDRegister())),
                  child: text("ليس لديك حساب؟", AppColor.secondary),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
          ],
        ),
      ),
    );
  }
}
