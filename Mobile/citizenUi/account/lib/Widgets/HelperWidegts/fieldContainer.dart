import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: file_names, non_constant_identifier_names


typedef FieldValidator = String? Function(String? value);
Widget FieldContainer(
  BuildContext context,
  String fieldName,
  bool isVisible,
  IconData fieldIcon,
  TextEditingController inputController,
    // FieldValidator? validator,
    TextInputType? keyboardType,
    int? maxLength,
    [bool enableAutofill = false]
) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double containerWidth = screenWidth * 0.75;
  const double containerHeight = 45;

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
        keyboardType: keyboardType,
        maxLength: maxLength,
        //  validator: validator,
        onSaved: (newValue) => inputController.text = newValue!,
        autofillHints: enableAutofill
            ? [AutofillHints.newUsername, AutofillHints.password]
            : null,
      ),
    ),
  );
}
