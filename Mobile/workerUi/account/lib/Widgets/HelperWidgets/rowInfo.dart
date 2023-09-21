import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';

Widget RowInfo(title, value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: AppColor.secondary,
                fontFamily: 'DroidArabicKufi',
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              ": " + title,
              style: const TextStyle(
                color: AppColor.main,
                fontFamily: 'DroidArabicKufi',
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
