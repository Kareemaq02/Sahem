import 'dart:convert';
import 'package:account/API/login_request.dart';
import 'package:http/http.dart' as http;

class TaskType {
  int intId;
  int intDepartmentId;
  String strNameAr;
  String strNameEn;

  TaskType({
    required this.intId,
    required this.strNameAr,
    required this.strNameEn,
    required this.intDepartmentId,
  });

  factory TaskType.fromJson(Map<String, dynamic> json) {
    return TaskType(
      intId: json['intId'],
      intDepartmentId: json['intDepartmentId'],
      strNameAr: json['strNameAr'],
      strNameEn: json['strNameEn'],
    );
  }
}

class TaskTypeRequest {
  Future<List<TaskType>> getAllCategory() async {
    var baseUrl = "https://10.0.2.2:5000/api/tasks/types";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token2',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as List;
      return jsonData.map((element) => TaskType.fromJson(element)).toList();
    } else {
      throw Exception('Failed to load complaint types');
    }
  }
}
