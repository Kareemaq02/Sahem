// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';

// ignore_for_file: unused_local_variable, file_names, prefer_const_constructors

class CountWidget extends StatefulWidget {
  final int initialCount;

  const CountWidget({super.key, 
    required this.initialCount,
  });

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  widget.initialCount.toString(),
                  style: TextStyle(color: AppColor.secondary),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xFFC9BD40),
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
