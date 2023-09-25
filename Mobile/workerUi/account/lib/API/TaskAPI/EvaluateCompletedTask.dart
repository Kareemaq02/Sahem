import 'package:account/Repository/urls.dart';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EvaluateCompletedTaskRequest {
  final userToken = prefs!.getString('token');

  Future<int> evaluateTask(
    int intTaskId,
    double decRating,
  ) async {
    try {
      final Uri url =
          Uri.parse("${AppUrl.baseURL}evaluations/complete/$intTaskId");

      final Map<String, dynamic> data = {
        'decRating': decRating,
      };

      final String jsonData = jsonEncode(data);

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $userToken",
          "Content-Type": "application/json",
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print('Task evaluated successfully.');
        return response.statusCode;
      } else {
        print('Failed with status code: ${response.statusCode}');
        return response.statusCode;
      }
    } catch (e) {
      print('Error: $e');
      return 400;
    }
  }
}
