


import 'package:account/Repository/color.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:flutter/material.dart';
Widget logoutBox(context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: 60,
      width: double.infinity,
      child:  Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
          children: [
            const Icon(Icons.logout_outlined, color: AppColor.secondary),
            const SizedBox(width: 8), // Add some spacing between icon and text
            TextButton(
              onPressed:() => {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const XDLogin()),
              )
              },
              child: const Text(
                "تسجيل الخروج",style: TextStyle(fontFamily:'DroidArabicKufi' ,color: AppColor.textBlue),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
