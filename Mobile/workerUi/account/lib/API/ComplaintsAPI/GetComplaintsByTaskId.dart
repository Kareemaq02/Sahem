import 'dart:convert';
import 'package:account/API/ComplaintsAPI/View_Complaints_Request.dart';
import 'package:account/Repository/urls.dart';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;

class GetComplaintsByTaskIdRequest {
  final userToken = prefs!.getString('token');
  Future<List<ComplaintModel>> getTasks(int taskId) async {
    final response = await http.get(
      Uri.parse("${AppUrl.baseURL}complaints/by/taskid/$taskId"),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<ComplaintModel> complaintsList = jsonData.map((json) {
        return ComplaintModel.fromJson(json);
      }).toList();

      return complaintsList;
    } else {
      throw Exception("Failed to fetch Task's complaints");
    }
  }
}
