// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_request.dart';

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
    var baseUrl = "https://10.0.2.2:5000/api/complaints/$complaintId";
    print(complaintId);
    http.Response response = await http.get(Uri.parse(baseUrl), headers: {'Authorization': 'Bearer $token2'});
    print(response.body);
    print(response.statusCode);
    print(response.reasonPhrase);
    print(response.headers);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as Map<String, dynamic>;
      ComplaintModel complaint = ComplaintModel.fromJson(jsonData);
      return [complaint];
    } else {
      throw response.statusCode;
    }
  }
}
