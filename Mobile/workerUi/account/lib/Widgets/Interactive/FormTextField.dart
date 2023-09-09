import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextField extends StatelessWidget {
  final double height;
  final double width;
  final TextEditingController controller;
  final String hintText;
  final bool? isDigitsOnly;
  final IconData? icon;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onChanged;

  const FormTextField({
    super.key,
    required this.height,
    required this.width,
    required this.controller,
    required this.hintText,
    this.contentPadding,
    this.isDigitsOnly,
    this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50 / (height * 0.02))),
        border: Border.all(
            color: AppColor.main, width: 1, style: BorderStyle.solid),
      ),
      child: Padding(
        padding: EdgeInsets.only(right: screenWidth * 0.03),
        child: TextFormField(
          style: const TextStyle(
            color: AppColor.main,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'DroidArabicKufi',
          ),
          onChanged: onChanged,
          controller: controller,
          textDirection: TextDirection.rtl,
          inputFormatters: isDigitsOnly != null
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          decoration: InputDecoration(
            contentPadding: contentPadding,
            hintTextDirection: TextDirection.rtl,
            hintStyle: const TextStyle(
              color: Color.fromARGB(111, 201, 44, 107),
              fontSize: 14,
              fontFamily: 'DroidArabicKufi',
            ),
            hintText: hintText,
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: Icon(
                icon,
                color: AppColor.main,
                size: screenHeight * 0.045,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
