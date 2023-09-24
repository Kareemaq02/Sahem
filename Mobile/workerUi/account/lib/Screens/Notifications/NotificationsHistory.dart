import 'package:account/API/login_request.dart';
import 'package:account/Utils/DateFormatter.dart';
import 'package:account/Widgets/Bars/NavBarAdmin.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:flutter/material.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';

class NotificationsHistory extends StatefulWidget {
  const NotificationsHistory({super.key});

  @override
  State createState() => _NotificationsHistoryState();
}

class _NotificationsHistoryState extends State<NotificationsHistory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: getCondtionalWidget(
        NavBarAdmin(0),
        BottomNavBar1(0),
        BottomNavBar1(0),
      ),
      appBar: myAppBar(context, "الإشعارات", false, screenWidth * 0.6),
      body: Center(
        child: Column(
          children: [
            notifiCard(
              screenWidth,
              screenHeight,
              471,
              StatusChoice.rejected,
              DateTime.now(),
            ),
            notifiCard(
              screenWidth,
              screenHeight,
              471,
              StatusChoice.approved,
              DateTime.now(),
            ),
            notifiCard(
              screenWidth,
              screenHeight,
              471,
              StatusChoice.inProgress,
              DateTime.now(),
            ),
            notifiCard(
              screenWidth,
              screenHeight,
              471,
              StatusChoice.completed,
              DateTime.now(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget notifiCard(double screenWidth, double screenHeight, int id,
    StatusChoice status, DateTime time) {
  return Padding(
    padding: EdgeInsets.only(
        left: screenWidth * 0.02,
        right: screenWidth * 0.02,
        top: screenHeight * 0.015),
    child: Container(
      height: screenHeight * 0.1,
      width: screenWidth * 0.92,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  statusIcon(status),
                  color: statusColor(status),
                  size: screenHeight * 0.045,
                ),
                TitleText(
                  text: "بلاغ رقم: #$id",
                  fontSize: 14,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(time),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  statusString(status),
                  style: TextStyle(
                    fontFamily: "DroidArabicKufi",
                    fontSize: 14,
                    color: statusColor(status),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

enum StatusChoice {
  rejected,
  approved,
  completed,
  inProgress,
}

IconData statusIcon(StatusChoice choice) {
  switch (choice) {
    case StatusChoice.rejected:
      return Icons.do_disturb_alt_rounded;
    case StatusChoice.approved:
      return Icons.task_alt_rounded;
    case StatusChoice.completed:
      return Icons.published_with_changes_rounded;
    case StatusChoice.inProgress:
      return Icons.donut_large_rounded;
    default:
      return Icons.error_outline_rounded;
  }
}

String statusString(StatusChoice choice) {
  switch (choice) {
    case StatusChoice.rejected:
      return "تم رفض البلاغ";
    case StatusChoice.approved:
      return "تمت الموافقه على البلاغ";
    case StatusChoice.completed:
      return "تم إنجاز البلاغ";
    case StatusChoice.inProgress:
      return "يتم العمل على البلاغ";
    default:
      return "غير معروف";
  }
}

Color statusColor(StatusChoice choice) {
  switch (choice) {
    case StatusChoice.rejected:
      return Colors.red[700]!;
    case StatusChoice.approved:
      return Colors.blue[700]!;
    case StatusChoice.completed:
      return Colors.green[700]!;
    case StatusChoice.inProgress:
      return Colors.orange[700]!;
    default:
      return Colors.grey;
  }
}
