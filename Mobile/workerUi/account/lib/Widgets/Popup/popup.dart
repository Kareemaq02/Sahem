import '../HelperWidgets/rowInfo.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Popup/popupBotton.dart';
import 'package:account/API/TaskAPI/submit_task_request.dart';


SubmitTask taskObj = SubmitTask();
//confirm complaint
Widget buildConfirmDialog(BuildContext context, title, title2, value, taskID,
    comment, selectedMediaFiles) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return AlertDialog(
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(fontFamily: 'DroidArabicKufi'),
    ),
    content: Container(
        width: screenWidth * 0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.06)),
        height: screenHeight * 0.17,
        child: Column(
          children: [
            RowInfo(title2, value),
            // RowInfo( , address),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Row(
                children: [
                  BottonContainerPopup(
                      "الغاء", AppColor.main, Colors.white, context, true, null,
                      () {
                    Navigator.of(context).pop();
                  }),
                  const SizedBox(
                    width: 3,
                  ),
                  BottonContainerPopup("استمرار", Colors.white, AppColor.main,
                      context, true, null, () {
                      
                    taskObj.submitTask(
                        context, taskID, selectedMediaFiles, comment);
                  }),
                ],
              ),
            ),
          ],
        )),
  );
}
