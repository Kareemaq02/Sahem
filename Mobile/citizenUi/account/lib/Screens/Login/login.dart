import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Validation/validations.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/Screens/Registration/register.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:account/Widgets/HelperWidegts/fieldContainer.dart';



TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
UserLogin user = UserLogin();
Validation a = Validation();

class XDLogin extends StatefulWidget {
  const XDLogin({Key? key}) : super(key: key);

  @override
  _XDLoginState createState() => _XDLoginState();
}

class _XDLoginState extends State<XDLogin> {
  //bool _autoValidate = false;

  // void _validateInputs() {
  //   if (_formKey1.currentState!.validate()) {
  //     _formKey1.currentState!.save();
  //   } else {
  //     setState(() {
  //      // _autoValidate = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Logobrand',
                  style: TextStyle(
                    fontFamily: 'DroidArabicKufi',
                    fontWeight: FontWeight.w100,
                    fontSize: 20,
                  ),
                ),
              ],
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
            ),
            
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
            ),
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
                  width: MediaQuery.of(context).padding.left + 35,
                ),
                text(
                  "تذكر تسجيل الدخول",
                  AppColor.main,
                ),
                const SizedBox(
                  width: 2.5,
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
                // _validateInputs();
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
                  onPressed: () => navigatorCostum(context, const XDRegister()),
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


navigatorCostum(BuildContext context, PageName) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PageName),
  );
}
