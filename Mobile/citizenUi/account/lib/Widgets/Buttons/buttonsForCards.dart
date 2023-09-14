// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget CardButtons(context, text, textColor, boxColor, width, whatToDo) {
  final screenWidth = MediaQuery.of(context).size.width;
  return Container(
    height: screenWidth * 0.077,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      border:
          Border.all(color: textColor, width: 1.3, style: BorderStyle.solid),
    ),
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(boxColor),
      ),
      onPressed: () {
        whatToDo();
      },
      child: Text(
        text,
        //textDirection: TextDirection.rtl,
        style: const TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
