import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';

Widget myLocationWidegt() {
  return Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: FloatingActionButton(
        backgroundColor: AppColor.background,
        heroTag: 'recenterr',
        onPressed: () {
          // setInitialLocation();
        },
        child: const Icon(
          Icons.my_location,
          color: AppColor.main,
        ),
      ),
    ),
  );
}
