import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';

Widget markerWidegt(int i) {
  return Stack(
    alignment: Alignment.center,
    children: [
      // Pin shape
      Container(
        width: 45,
        height: 45,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
              color: AppColor.main,
              offset: Offset(0, 3),
              spreadRadius: 2,
              blurRadius: 20,
            ),
          ],
        ),
        child:  CircleAvatar(
          radius: 15,
          backgroundImage: AssetImage(
            'assets/imges2/pic${i % 25}.jpg',
          ),
        ),
      ),
    ],
  );
}

Widget clusterWidget(clusterSize) {
  return Container(
    width: 70,
    height: 70,
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      //color: Colors.white,
      borderRadius: BorderRadius.circular(100),
      boxShadow: const [
        BoxShadow(
          color: AppColor.main,
          offset: Offset(0, 3),
          spreadRadius: 4,
          blurRadius: 6,
        ),
      ],
    ),
    child: Center(
      child: Text(
        clusterSize.toString(),
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    ),
  );
}
