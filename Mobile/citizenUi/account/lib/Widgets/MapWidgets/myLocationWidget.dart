import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
// import 'package:account/Widgets/Filter/filterType.dart';
// ignore_for_file: file_names

Widget myLocationWidegt(
  Function() onPressed,
) {
  return Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: FloatingActionButton(
        backgroundColor: AppColor.background,
        onPressed: () {
          onPressed();
        },
        child: const Icon(
          Icons.my_location,
          color: AppColor.main,
        ),
      ),
    ),
  );
}

Widget filterIcon(context) {
  return Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 80.0, right: 10),
      child: FloatingActionButton(
        backgroundColor: AppColor.background,
        heroTag: 'recenterr',
        onPressed: () {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) => const FilterPopup(),
          // );
        },
        child: const Icon(
          Icons.filter_alt_sharp,
          color: AppColor.line,
        ),
      ),
    ),
  );
}
