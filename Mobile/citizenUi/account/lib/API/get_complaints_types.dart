import 'dart:io';
import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart'as http;
import 'package:account/Repository/urls.dart';
import 'package:account/API/login_request.dart';

// ignore_for_file: avoid_print, use_build_context_synchronously, unnecessary_string_escapes, unused_import


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
  final token2 = prefs!.getString('token');
Future<List<ComplaintType>> getAllCategory() async {
  var baseUrl = "${AppUrl.baseURL}/complaints/types";
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
