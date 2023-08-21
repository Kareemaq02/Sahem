// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, file_names

import 'package:account/API/login_request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class PublicComplaintModel {
  final int intComplaintId;
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
 

  PublicComplaintModel({
    required this.intComplaintId,
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
  });

//   factory PublicComplaintModel.fromJson(Map<String, dynamic> json) {
//     return PublicComplaintModel(
//       intComplaintId: json['intComplaintId'],
//       strUserName: json['strUserName'],
//       dtmDateCreated: json['dtmDateCreated'],
//       dtmDateFinished: json['dtmDateFinished'],
//       strComplaintTypeEn: json['strComplaintTypeEn'],
//       strComplaintTypeAr: json['strComplaintTypeAr'],
//       strComment: json['strComment'],
//       strStatus: json['strStatus'],
//       intPrivacyId: json['intPrivacyId'],
//       intVotersCount: json['intVotersCount'],
//       decLat: json['decLat'],
//       decLng: json['decLng'],
//       decPriority: json['decPriority'],
    
//     );
//   }
}



Future<List<dynamic>> getComplaintsByLocation(double decLat, double decLng) async {
 // String token2='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lIiwiZmlyc3ROYW1lIjoiZmlyc3QiLCJsYXN0TmFtZSI6Imxhc3QiLCJwaG9uZU51bWJlciI6IjAxMjM0NTY3ODkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2ODg2NTEwMDYsImV4cCI6MTY5MTI0MzAwNiwiaWF0IjoxNjg4NjUxMDA2fQ.NJPnHG4WNtnelTqJm7KNGY4Jf6j3j7XZ5zOMHpALDBM';
  final url = Uri.parse('https://10.0.2.2:5000/api/complaints/location');
  final body = json.encode({'decLat': decLat, 'decLng': decLng});

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token2'},

    body : body,
  );
// print(response.body);
// print(response.statusCode);
  if (response.statusCode == 200) {
    List<dynamic> complaints = json.decode(response.body);
    return complaints;
  } else {
    throw Exception('Failed to load complaints');
  }
}