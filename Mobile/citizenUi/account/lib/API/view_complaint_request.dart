// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, avoid_print




import 'dart:convert';

//import 'package:account/API/login_request.dart';
import 'package:http/http.dart' as http;


class ComplaintModel {
  final int intId;
  final String strUserName;
  final String dtmDateCreated;
  final String dtmDateFinished;
  final String strComplaintTypeEn;
  final String strComplaintTypeAr;
  final String? strComment;
  final String? strStatus;
  final  intPrivacyId;
  final  intVotersCount;
  final  decLat;
  final  decLng;
  final int decPriority;
  final List<dynamic> lstMedia;
  final bool blnIsVideo;

  ComplaintModel({
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
    required this.lstMedia,
    required this.blnIsVideo,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
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
      lstMedia: json['lstMedia'],
      blnIsVideo: json['blnIsVideo'],
    );
  }
}

class getUserComplaint {
  
  Future<List<ComplaintModel>> getComplaintById(String complaintId) async {
     String token2='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lIiwiZmlyc3ROYW1lIjoiZmlyc3QiLCJsYXN0TmFtZSI6Imxhc3QiLCJwaG9uZU51bWJlciI6IjAxMjM0NTY3ODkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2ODg2NTEwMDYsImV4cCI6MTY5MTI0MzAwNiwiaWF0IjoxNjg4NjUxMDA2fQ.NJPnHG4WNtnelTqJm7KNGY4Jf6j3j7XZ5zOMHpALDBM';
    var baseUrl = "https://10.0.2.2:5000/api/complaints/$complaintId";
    print(complaintId);
    http.Response response = await http.get(Uri.parse(baseUrl), headers: {'Authorization': 'Bearer $token2'});

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as Map<String, dynamic>;
      ComplaintModel complaint = ComplaintModel.fromJson(jsonData);
      return [complaint];
    } else {
      throw response.statusCode;
    }
  }
}
