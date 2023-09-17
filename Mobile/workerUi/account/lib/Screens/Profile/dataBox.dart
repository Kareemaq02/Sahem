import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: file_names

// ignore_for_file: non_constant_identifier_names


Widget DataBox(String label, widget, data) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0),
    child: Container(
      width: double.infinity,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
          child: Text(
            label,
            textAlign: TextAlign.end,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: AppColor.main,
              fontSize: 10,
              fontWeight: FontWeight.w100,
              fontFamily: 'DroidArabicKufi',
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              widget(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  data,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColor.secondary,
                    fontSize: 12,
                    fontFamily: 'DroidArabicKufi',
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    ),
  );
}

Widget InfoBox(name, id) {
  return Container(
      width: double.infinity,
      height: 80,
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
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: .2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2.5,
                color: AppColor.main,
              ),
            ),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColor.main,
                fontSize: 20,
                fontFamily: 'DroidArabicKufi',
              ),
            ),
            Text(
              'الرقم الوطني: $id',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColor.secondary,
                fontSize: 11,
                fontFamily: 'DroidArabicKufi',
              ),
            ),
          ]),
        ),
      ));
}
