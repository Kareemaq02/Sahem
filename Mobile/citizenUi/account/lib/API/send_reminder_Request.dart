import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:account/API/login_request.dart';

class ComapalintReminder {
  Future<dynamic> comaplintReminder(int id, context) async {
    final url = Uri.parse("https://10.0.2.2:5000/api/complaints/remind/$id");

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
        _showDialog("تم إرسال تذكير بنجاح", context, response.statusCode);
        return {};
      } else if (response.statusCode == 400) {
        final responseBody = jsonDecode(response.body);
        _showDialog(responseBody, context, response.statusCode);
        return responseBody;
      } else {
        return null;
      }
    } catch (error) {
      _showDialog('لا يمكن إرسال تذكير الأن. ', context, 401);
      return null;
    }
  }
}

void _showDialog(String message, context, statusCode) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              statusCode == 200
                  ? Icons.check_circle_outline
                  : Icons.error_outline,
              size: 40,
              color: statusCode == 200 ? Colors.green : Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                message,
                softWrap: true,
              ),
            ),
          ],
        ),
        actions: <Widget>[],
      );
    },
  );
}
