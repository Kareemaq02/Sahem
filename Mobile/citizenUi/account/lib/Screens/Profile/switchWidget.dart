// ignore_for_file: file_names

import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';


bool status =false;
Widget switchV() {
  return Transform.scale(
    scale: 0.7, // Change the scale factor to resize the Switch
    child: Switch(
      activeColor: Colors.white,
      activeTrackColor:AppColor.main ,
      value: status,
      onChanged: (value) {
        // setState(() {
        //   status = value; // Update the state based on the click
        // });
      },
      splashRadius: 20,
    ),
  );
}


List<bool> _isSelected = [true, false];

Widget toggleLang() {
  return SizedBox(
    //width: 80, // Set the desired width
    height: 25, // Set the desired height
    child: ToggleButtons(
      renderBorder: true,
      borderColor: AppColor.main, // Make sure AppColor.main is defined
      borderRadius: BorderRadius.circular(20),
      isSelected: _isSelected,
      color: Colors.grey,
      selectedColor: Colors.white,
      fillColor: AppColor.main,
      onPressed: (int index) {
        // setState(() {
        //   _isSelected[index] = !_isSelected[index];
        // });
      },
      children: const <Widget>[
        Text('En',style: TextStyle(fontSize: 10),),
        Text('ع',style: TextStyle(fontSize: 10),),
      ],
    ),
  );
}

