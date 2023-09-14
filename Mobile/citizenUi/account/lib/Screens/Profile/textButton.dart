// ignore_for_file: unused_local_variable, file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/edit_user_info_request.dart';

class EditButton extends StatefulWidget {
  final String label;
  final String currentData;

  const EditButton({super.key, 
    required this.label,
    required this.currentData,
  });

  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController textController =
            TextEditingController(text: widget.currentData);
        TextEditingController newUsername = TextEditingController();
        TextEditingController newEmail = TextEditingController();
        TextEditingController newPhone = TextEditingController();
        TextEditingController newLocation = TextEditingController();
        TextEditingController newPassword = TextEditingController();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: TextField(
              controller: textController,
              autofocus: true,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.grey, fontFamily: 'DroidArabicKufi'),
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: "",
                labelStyle: const TextStyle(
                  color: AppColor.main,
                  fontFamily: 'DroidArabicKufi',
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.main),
                ),
              ),
            ),
            actions: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'رجوع',
                        style: TextStyle(
                          color: AppColor.main,
                          fontFamily: 'DroidArabicKufi',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        String editedData = textController.text;
                        EditInfo edit = EditInfo();
                        edit.updateAccount(
                          newUsername.text,
                          editedData,
                          newPassword.text,
                          newPhone.text,
                          newLocation.text,
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'حفظ',
                        style: TextStyle(
                          color: AppColor.main,
                          fontFamily: 'DroidArabicKufi',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showDialog();
      },
      child: const Text(
        'تغير',
        style: TextStyle(
          color: AppColor.main,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'DroidArabicKufi',
        ),
      ),
    );
  }
}
