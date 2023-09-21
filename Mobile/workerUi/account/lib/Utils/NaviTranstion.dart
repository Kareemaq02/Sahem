import 'package:flutter/material.dart';
// ignore_for_file: file_names


naviTransition(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, a, __, c) {
        var scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(a);
        return ScaleTransition(
          scale: scaleAnimation,
          child: c,
        );
      },
    ),
  );
}
