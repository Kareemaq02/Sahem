import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/Profile/textButton.dart';
// ignore_for_file: file_names, non_constant_identifier_names

Widget DataBox(String label, [data, bool isEditable = true]) {
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
              Visibility(
                  //visible: isEditable,
                  child: !isEditable
                      ? Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            activeColor: Colors.white,
                            activeTrackColor: AppColor.main,
                            value: false,
                            onChanged: (value) {
                              // setState(() {
                              //   status = value;
                              // });
                            },
                            splashRadius: 20,
                          ),
                        )
                      : EditButton(label: label, currentData: data)),
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

Widget InfoBox(name, nationalID) {
  return Container(
      height: 95,
      width: double.infinity,
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
              'الرقم الوطني:$nationalID',
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
