import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';

class TeamMemberDisplay extends StatelessWidget {
  final double height;
  final double width;
  final String name;
  final IconData icon;
  final Color color;

  const TeamMemberDisplay({
    super.key,
    required this.height,
    required this.width,
    required this.name,
    required this.icon,
    required this.color,
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
          border: Border.all(
              color: color == AppColor.main ? AppColor.line : color, width: 1),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: height * 0.1,
                    left: width * 0.05,
                    right: width * 0.05),
                child: Text(
                  name,
                  textDirection:
                      isArabic() ? TextDirection.rtl : TextDirection.ltr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color == AppColor.main ? color : AppColor.textTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DroidArabicKufi',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.15),
                child: Icon(
                  icon,
                  color: color,
                  size: height * 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
