import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
// ignore_for_file: file_names


class ComplaintType {
  final userToken = prefs!.getString('token');
  int intTypeId;
  String strNameAr;
  String strNameEn;
  double decGrade;
  int intPrivacyId;
  String strPrivacyEn;
  String strPrivacyAr;
  int intDepartmentId;

  ComplaintType({
    required this.intTypeId,
    required this.strNameAr,
    required this.strNameEn,
    required this.decGrade,
    required this.intPrivacyId,
    required this.strPrivacyEn,
    required this.strPrivacyAr,
    required this.intDepartmentId,
  });

  factory ComplaintType.fromJson(Map<String, dynamic> json) {
    return ComplaintType(
      intTypeId: json['intTypeId'],
      strNameAr: json['strNameAr'],
      strNameEn: json['strNameEn'],
      decGrade: json['decGrade'],
      intPrivacyId: json['intPrivacyId'],
      strPrivacyEn: json['strPrivacyEn'],
      strPrivacyAr: json['strPrivacyAr'],
      intDepartmentId: json['intDepartmentId'],
    );
  }
}

class ComplaintTypeRequest {
  final userToken = prefs!.getString('token');
  Future<List<ComplaintType>> getAllCategory() async {
    var baseUrl = "${AppUrl.baseURL}complaints/types";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as List;
      return jsonData
          .map((element) => ComplaintType.fromJson(element))
          .toList();
    } else {
      throw Exception('Failed to load complaint types');
    }
  }
}
