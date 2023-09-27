import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Base64ImageDisplay extends StatelessWidget {
  final String base64String;

  const Base64ImageDisplay(this.base64String, {super.key});

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = Uint8List.fromList(base64.decode(base64String));

    return Image.memory(
      bytes,
      scale: 0.1,
      fit: BoxFit.fill,
    );
  }
}
