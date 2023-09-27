import 'package:account/Repository/color.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:flutter/material.dart';

class TeamMemberAnalyticsDisplay extends StatelessWidget {
  final double height;
  final double width;
  final String name;
  final double rating;
  final IconData icon;
  final Color color;

  const TeamMemberAnalyticsDisplay({
    super.key,
    required this.height,
    required this.width,
    required this.name,
    required this.icon,
    required this.color,
    required this.rating,
  });

  bool isArabic() {
    int charCode = name.codeUnitAt(0);

    if ((charCode >= 0x0600 && charCode <= 0x06FF) ||
        (charCode >= 0x0750 && charCode <= 0x077F)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      textDirection:
                          isArabic() ? TextDirection.rtl : TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColor.textTitle,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DroidArabicKufi',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: height * 0.05),
                          child: const Icon(
                            Icons.star_rate_rounded,
                            color: AppColor.line,
                          ),
                        ),
                        TitleText(text: rating.toStringAsFixed(1))
                      ],
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.35),
                child: Icon(
                  icon,
                  color: color,
                  size: height * 0.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
