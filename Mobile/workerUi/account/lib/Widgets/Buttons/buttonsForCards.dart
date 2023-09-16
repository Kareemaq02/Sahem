import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: file_names

Widget CardButtons(context, text, textColor, boxColor, width, whatToDo) {
  final screenWidth = MediaQuery.of(context).size.width;
  return Container(
    height: screenWidth * 0.077,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40),
    ),
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: AppColor.main, width: 2),
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
        style: const TextStyle(
          color: AppColor.main,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: 'DroidArabicKufi',
        ),
      ),
    ),
  );
}
