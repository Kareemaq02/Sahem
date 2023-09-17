import 'package:flutter/material.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:account/Widgets/CheckBoxes/StyledCheckBox.dart';
import 'package:account/Widgets/Interactive/FormTextField.dart';
// ignore_for_file: library_private_types_in_public_api

// ignore_for_file: file_names


class CheckBoxPopup extends StatefulWidget {
  final double height;
  final String title;
  final List<StyledCheckBox> checkBoxes;
  final void Function(String)? search;

  const CheckBoxPopup({
    Key? key,
    required this.height,
    required this.title,
    required this.checkBoxes,
    required this.search,
  }) : super(key: key);

  @override
  _CheckBoxPopupState createState() => _CheckBoxPopupState();
}

class _CheckBoxPopupState extends State<CheckBoxPopup> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: widget.height * 0.15,
              child: Padding(
                padding: EdgeInsets.only(
                  top: widget.height * 0.02,
                  bottom: widget.height * 0.04,
                ),
                child: TitleText(text: widget.title),
              ),
            ),
            SizedBox(
              height: widget.height * 0.1,
              child: StatefulBuilder(
                builder: (context, setStateInsideDialog) {
                  return FormTextField(
                    height: widget.height * 0.1,
                    width: screenWidth * 0.6,
                    icon: Icons.search_rounded,
                    controller: controller,
                    contentPadding: EdgeInsets.only(top: widget.height * 0.005),
                    onChanged: (query) {
                      widget.search?.call(query);
                      setStateInsideDialog(() {});
                    },
                    hintText: "بحث",
                  );
                },
              ),
            ),
            SizedBox(
              height: widget.height * 0.1,
            ),
            SizedBox(
              height: widget.height * 0.5,
              child: widget.checkBoxes.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.27),
                      child: Column(
                        children: widget.checkBoxes,
                      ),
                    )
                  : const TitleText(
                      text: "لا يوجد نتائج",
                      fontSize: 14,
                    ),
            ),
            SizedBox(
              height: widget.height * 0.1,
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
  }
}
