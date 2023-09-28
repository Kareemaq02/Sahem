import 'dart:convert';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/API/signup_request.dart';
import 'package:account/Screens/Login/login.dart';
import '../../Repository/language_constants.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:account/Screens/Registration/register.dart';
import 'package:account/Screens/Registration/register1.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
import 'package:account/Widgets/HelperWidegts/fieldContainer.dart';
// ignore_for_file: constant_identifier_names, unused_element, unused_import, depend_on_referenced_packages, avoid_print, library_private_types_in_public_api

String dropdownValue = "";
late List<String> dropdownItems;
Map<String, String> _nationalities = {};
TextEditingController passportNumController = TextEditingController();
TextEditingController nationalityController = TextEditingController();

Future<void> loadNationalities() async {
  final jsonString = await rootBundle.loadString('assets/data.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonString);
  print(jsonMap.length);
  jsonMap.forEach((key, value) {
    _nationalities[key] = value.toString();
  });
}

class XDRegister2 extends StatefulWidget {
  const XDRegister2({
    Key? key,
  }) : super(key: key);
  @override
  _XDRegister2State createState() => _XDRegister2State();
}

class _XDRegister2State extends State<XDRegister2> {
  TextEditingController usernameController3 = TextEditingController();
  TextEditingController passwordController3 = TextEditingController();
  UserSignup user = UserSignup();
  @override
  void initState() {
    super.initState();
    loadNationalities();
    //dropdownValue = _nationalities.keys.first;
    print(dropdownValue);
  }

  Widget dropDownWidget(
      context, String fieldName, bool isVisible, fieldIcon, inputController) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth * 0.75;
    const double containerHeight = 45;

    return Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          border: Border.all(
              color: AppColor.main, width: 1, style: BorderStyle.solid),
        ),
        child: TypeAheadFormField<String>(
          initialValue: null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textFieldConfiguration: TextFieldConfiguration(
            controller: nationalityController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xff6f407d),
                ),
              ),
            ),
            style: const TextStyle(color: Color(0xff6f407d)),
          ),
          suggestionsCallback: (pattern) {
            return _nationalities.values.where((nationality) =>
                nationality.toLowerCase().contains(pattern.toLowerCase()));
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: (suggestion) {
            setState(() {
              dropdownValue = suggestion;
              nationalityController.text = suggestion;
            });
          },
          getImmediateSuggestions: true,
        ));
  }

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
                  height: 30,
                ),
                FieldContainer(
                  context,
                  'رقم جواز السفر',
                  false,
                  Icons.account_circle,
                  passportNumController,
                  TextInputType.text,
                  null,
                ),
                const SizedBox(
                  height: 10,
                ),
                // FieldContainer( context,'جنسية' ,false,Icons.account_circle,nationalityController
                // ,TextInputType.emailAddress, // For email input
                //             null,),
                const SizedBox(
                  height: 10,
                ),
                FieldContainer(
                  context,
                  ' اسم المستخدم ',
                  false,
                  Icons.email,
                  usernameController3,
                  TextInputType.text,
                  null,
                ),
                const SizedBox(
                  height: 10,
                ),
                FieldContainer(
                  context,
                  ' كلمةالمرور',
                  false,
                  Icons.phone,
                  passwordController3,
                  TextInputType.visiblePassword,
                  null,
                ),
                const SizedBox(
                  height: 15,
                ),

                const SizedBox(
                  height: 10,
                ),

                BottonContainer("استمرار", Colors.white, AppColor.main, 240,
                    context, true, "", () {
                  user.signup(
                      usernameController3.text,
                      PhoneController.text,
                      passwordController3.text,
                      FnameController.text,
                      LnameController.text,
                      EmailController.text,
                      nationalNumController.text,
                      passportNumController.text,
                      regNumberController.text,
                      iDNumbberController.text,
                      context);
                }),
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
        ));
  }
}
