import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';


typedef String? FieldValidator(String? value);
Widget FieldContainer(
  BuildContext context,
  String fieldName,
  bool isVisible,
  IconData fieldIcon,
  TextEditingController inputController,
  FieldValidator? validator, // Validator function for input validation
  TextInputType? keyboardType, // Specify the keyboard type
  int? maxLength, // Specify the maximum length
) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double containerWidth = screenWidth * 0.75;
  final double containerHeight = 45;

  return Container(
    height: containerHeight,
    width: containerWidth,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      border: Border.all(
        color: AppColor.main,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
    child: Align(
      child: TextFormField(
        controller: inputController,
        obscureText: isVisible,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintTextDirection: TextDirection.rtl,
          hintStyle: const TextStyle(
            color: AppColor.main,
            fontSize: 11,
            fontFamily: 'DroidArabicKufi',
          ),
          hintText: fieldName,
          suffixIcon: Icon(
            fieldIcon,
            color: AppColor.main,
            size: 20,
          ),
          border: InputBorder.none,
        ),
        keyboardType: keyboardType, // Set the keyboard type
        maxLength: maxLength, // Set the maximum length
        validator: validator, // Set the validator function
      ),
    ),
  );
}
