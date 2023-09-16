import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: file_names

// ignore_for_file: non_constant_identifier_names

Widget CardButtons(
  context,
  text,
  textColor,
  boxColor,
  width,
  borderColor,
  whatToDo,
) {
  final screenWidth = MediaQuery.of(context).size.width;
  return Container(
    height: screenWidth * 0.077,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40), 
    ),
    child: ElevatedButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(AppColor.main),
        backgroundColor: MaterialStateProperty.all<Color>(boxColor),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: borderColor, width: 2),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      onPressed: () {
        whatToDo();
      },
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: 'DroidArabicKufi',
        ),
      ),
    ),
  );
}

