import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: avoid_types_as_parameter_names
// ignore: non_constant_identifier_names

Widget Mycontainer(double height, Widget) {
  return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1.5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: .2),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2.4,
                  color: AppColor.main,
                ),
              ),
            ),
            child: Widget,
          )));
}
