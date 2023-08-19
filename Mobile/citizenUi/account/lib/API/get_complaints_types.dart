
// ignore_for_file: avoid_print, use_build_context_synchronously, unnecessary_string_escapes, unused_import

import 'dart:convert';
import 'dart:io';
import 'package:account/API/login_request.dart';
import 'package:http/http.dart'as http;

class ComplaintType {
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
// Factory method to create a ComplaintType object from JSON
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


class ComplaintTypeRequest{
Future<List<ComplaintType>> getAllCategory() async {
   String token2='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lIiwiZmlyc3ROYW1lIjoiZmlyc3QiLCJsYXN0TmFtZSI6Imxhc3QiLCJwaG9uZU51bWJlciI6IjAxMjM0NTY3ODkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2ODg2NTEwMDYsImV4cCI6MTY5MTI0MzAwNiwiaWF0IjoxNjg4NjUxMDA2fQ.NJPnHG4WNtnelTqJm7KNGY4Jf6j3j7XZ5zOMHpALDBM';
  var baseUrl = "https://10.0.2.2:5000/api/complaints/types";
  http.Response response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      'Authorization': 'Bearer $token2',
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
