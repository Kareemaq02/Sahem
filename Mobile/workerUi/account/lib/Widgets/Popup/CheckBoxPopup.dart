import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/CheckBoxes/checkBox.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:flutter/material.dart';

class CheckBoxPopup {
  final double height;
  final String title;

  const CheckBoxPopup({
    required this.height,
    required this.title,
  });

  void showCheckBoxDialog(
      BuildContext context, List<StyledCheckBox> checkBoxes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: height * 0.15,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.02, bottom: height * 0.04),
                    child: TitleText(text: title),
                  ),
                ),
                SizedBox(
                  height: height * 0.7,
                  child: Column(
                    children: checkBoxes,
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                  child: StyledButton(
                    text: "موافق",
                    fontSize: 14,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
