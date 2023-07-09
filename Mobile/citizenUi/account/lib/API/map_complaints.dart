// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, avoid_print
import 'dart:convert';

import 'package:account/API/login_request.dart';
import 'package:http/http.dart' as http;

class ComplaintModel2 {
  final int intId;
  final String strUserName;
  final String dtmDateCreated;
  final String dtmDateFinished;
  final String strComplaintTypeEn;
  final String strComplaintTypeAr;
  final String? strComment;
  final String? strStatus;
  final int intPrivacyId;
  final int intVotersCount;
  final double? decLat;
  final double? decLng;
  final  decPriority;
  //final List<dynamic> lstMedia;
  final bool? blnIsVideo;

  ComplaintModel2({
    required this.intId,
    required this.strUserName,
    required this.dtmDateCreated,
    required this.dtmDateFinished,
    required this.strComplaintTypeEn,
    required this.strComplaintTypeAr,
    required this.strComment,
    required this.strStatus,
    required this.intPrivacyId,
    required this.intVotersCount,
    required this.decLat,
    required this.decLng,
    required this.decPriority,
    //required this.lstMedia,
    required this.blnIsVideo,
  });

  factory ComplaintModel2.fromJson(Map<String, dynamic> json) {
    return ComplaintModel2(
      intId: json['intComplaintId'],
      strUserName: json['strUserName'],
      dtmDateCreated: json['dtmDateCreated'],
      dtmDateFinished: json['dtmDateFinished'],
      strComplaintTypeEn: json['strComplaintTypeEn'],
      strComplaintTypeAr: json['strComplaintTypeAr'],
      strComment: json['strComment'],
      strStatus: json['strStatus'],
      intPrivacyId: json['intPrivacyId'],
      intVotersCount: json['intVotersCount'],
      decLat: json['decLat'],
      decLng: json['decLng'],
      decPriority: json['decPriority'],
      //lstMedia: json['lstMedia'],
      blnIsVideo: json['blnIsVideo'],
    );
  }
}

class getUsersComplaint {
  String token2="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFidXJ1bW1hbm4iLCJmaXJzdE5hbWUiOiJydWJhIiwibGFzdE5hbWUiOiJhYnVydW1tYW4iLCJwaG9uZU51bWJlciI6IjA3OTg5ODk5OTkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2ODg2NDUyOTgsImV4cCI6MTY5MTIzNzI5OCwiaWF0IjoxNjg4NjQ1Mjk4fQ.b9clyTj4T7T46N81pRLKJKTfpxMPzncEUR5S72m1EPA";
  Future<List<ComplaintModel2>> getComplaints() async {
    var baseUrl = "https://10.0.2.2:5000/api/complaints";

    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token2'},
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as List<dynamic>;
      List<ComplaintModel2> complaints = [];

      jsonData.forEach((complaintData) {
        var complaint = ComplaintModel2.fromJson(complaintData);
        complaints.add(complaint);
      });

      return complaints;
    } else {
      throw Exception('Failed to get complaints. Status code: ${response.statusCode}');
    }
  }
}
