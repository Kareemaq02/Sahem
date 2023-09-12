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
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.1),
                child: Text(
                  name,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
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
