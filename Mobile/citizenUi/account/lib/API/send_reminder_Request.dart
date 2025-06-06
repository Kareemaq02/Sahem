import 'dart:convert';
import 'package:account/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';

// ignore_for_file: file_names, avoid_print


class ComapalintReminder {
   final token2 = prefs!.getString('token');
  Future<dynamic> comaplintReminder(int id, context1) async {
    final url = Uri.parse("${AppUrl.baseURL}/complaints/remind/$id");

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token2'
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        _showDialog("تم إرسال تذكير بنجاح", context1, response.statusCode);
        return {};
      } else if (response.statusCode == 400) {
        final responseBody = jsonDecode(response.body);
        _showDialog(responseBody, context1, response.statusCode);
        return responseBody;
      } else {
        return null;
      }
    } catch (error) {
      _showDialog('لا يمكن إرسال تذكير الأن. ', context1, 401);
      return null;
    }
  }
}

void _showDialog(String message, BuildContext context1, int statusCode) {
  showDialog(
    context: context1, 
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Icon(
                statusCode == 200
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                size: 40,
                color: statusCode == 200 ? Colors.green : Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                message,
                textDirection: TextDirection.rtl,
                //softWrap: true,
                style: const TextStyle(
                  fontFamily: 'DroidArabicKufi',
                ),
              ),
            ),
          ],
        ),
        actions: const <Widget>[],
      );
    },
  );
}
