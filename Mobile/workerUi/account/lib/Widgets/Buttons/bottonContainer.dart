import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: non_constant_identifier_names



// ignore_for_file: file_names


Widget BottonContainer(
  String text,
  textColor,
  Color boxColor,
  double width,
  BuildContext context,
  bool apiFlag,
  pageName,
  Function()? onPressed, 
) {
  return SizedBox(
    height: 49,
    width: width,
    child: ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        backgroundColor: MaterialStateProperty.all<Color>(boxColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side:const BorderSide(
              color: AppColor.main,
              width: 1.3,
            ),
          ),
        ),
      ),
      onPressed: () {
        if (!apiFlag) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pageName),
          );
        } else {
          if (onPressed != null) {
            onPressed(); 
          }
        }
      },
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: textColor,
          fontSize: 15,
          fontFamily: 'DroidArabicKufi',
        ),
      ),
    ),
  );
}



