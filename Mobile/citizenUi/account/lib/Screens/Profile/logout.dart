import 'package:account/main.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/Login/login.dart';




Widget logoutBox(context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () => {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const XDLogin()),
          (route) => false,
        ),
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 60,
        width: double.infinity,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_outlined, color: AppColor.secondary),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => {
                  prefs!.setString('token', ""),
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const XDLogin()),
                    (route) => false,
                  ),
                },
                child: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(
                      fontFamily: 'DroidArabicKufi', color: AppColor.textBlue),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
