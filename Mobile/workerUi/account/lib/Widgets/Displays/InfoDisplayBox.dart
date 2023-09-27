import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';

class InfoDisplayBox extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final String content;
  final IconData? icon;
  final Color? iconColor;
  final bool? displayStar;

  const InfoDisplayBox({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
    this.displayStar = false,
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
                          fontSize: 12,
                          fontFamily: 'DroidArabicKufi',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: icon == null
                        ? Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Visibility(
                                      visible: displayStar!,
                                      child: const Icon(
                                        Icons.star,
                                        color: AppColor.line,
                                      )),
                                ),
                                Text(
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
                              ],
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(right: width * 0.05),
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: height * 0.05),
                                    child: Icon(
                                      icon,
                                      color: iconColor,
                                      size: height * 0.225,
                                    ),
                                  ),
                                  Text(
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
                                ],
                              ),
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
