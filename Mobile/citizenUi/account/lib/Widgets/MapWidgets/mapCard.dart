import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/HelperWidegts/RowInfo.dart';
import 'package:account/Widgets/MapWidgets/mapPageView.dart';
import 'package:account/Screens/View%20complaints/complaints_details.dart';
// ignore_for_file: unused_import

// ignore_for_file: file_names



mapCard(context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          content: SizedBox(
            height: screenHeight * 0.55,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: screenHeight * 0.3,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                        //color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: mapPageView(context),
                  ),
                  const Divider(
                    color: AppColor.line,
                    thickness: 1.5,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  RowInfo("رقم البلاغ", "2526"),
                  RowInfo("نوع البلاغ", "تراكم نفايات"),
                  RowInfo("تاربخ الانتهاء", "قبل 5 ساعات"),
                  RowInfo("موقع البلاغ", "ش.وصفي التل"),
                ],
              ),
            ),
          ),
        );
      });
}

Widget beforeAfter() {
  return Container();
}
