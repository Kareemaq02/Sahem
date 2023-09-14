// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: avoid_types_as_parameter_names
// ignore: non_constant_identifier_names

Widget myContainer(double height, Widget childWidget) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 0.2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 3.5,
                color: AppColor.main,
              ),
            ),
          ),
          child: childWidget,
        ),
      ),
    ),
  );
}
