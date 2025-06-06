import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
// ignore_for_file: file_names


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
    final userToken =prefs!.getString('token');
  Future<List<TaskType>> getAllCategory() async {
    var baseUrl = "${AppUrl.baseURL}tasks/types";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as List;
      return jsonData.map((element) => TaskType.fromJson(element)).toList();
    } else {
      throw Exception('Failed to load task types');
    }
  }
}
