import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';

Widget RowInfo(title, value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        flex: 2,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              textDirection: TextDirection.rtl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.bold,
                fontFamily: 'DroidArabicKufi',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "$title:",
              textDirection: TextDirection.rtl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColor.main,
                fontFamily: 'DroidArabicKufi',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
