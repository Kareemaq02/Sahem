import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: file_names


class InfoDisplayBox extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final String content;

  const InfoDisplayBox({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   border: Border.all(
        //     color: AppColor.main,
        //     width: 1.0,
        //   ),
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        title,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: AppColor.textTitle,
                          fontSize: 14,
                          fontFamily: 'DroidArabicKufi',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        content,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: AppColor.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'DroidArabicKufi',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
