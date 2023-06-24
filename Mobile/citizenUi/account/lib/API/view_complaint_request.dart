// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_request.dart';

class ComplaintModel {
  final int intId;
  final int intUserId;
  final int intTypeId;
  final  complaintType;
  final int intStatusId;
  final  status;
  final String strComment;
  final int intReminder;
  final String dtmDateCreated;
  final String dtmDateLastReminded;
  final int intLastModifiedBy;
  final String dtmDateLastModified;
  final  voters;
  final attachments;
  final tasks;

  ComplaintModel({
    this.complaintType="",
    required this.intStatusId, 
    this.status="", 
    required this.voters, 
    required this.attachments, 
    required this.tasks, 
    required this.intId,
    required this.intUserId,
    required this.intTypeId,
    required this.strComment,
    required this.intReminder,
    required this.dtmDateCreated,
    required this.dtmDateLastReminded,
    required this.intLastModifiedBy,
    required this.dtmDateLastModified,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      intId: json['intId'],
      intUserId: json['intUserID'],
      intTypeId: json['intTypeId'],
      complaintType:json['complaintType'],
      intStatusId:json['intStatusId'],
      status:json['status'],
      strComment: json['strComment'],
      intReminder: json['intReminder'],
      dtmDateCreated: json['dtmDateCreated'],
      dtmDateLastReminded: json['dtmDateLastReminded'],
      intLastModifiedBy: json['intLastModifiedBy'],
      dtmDateLastModified: json['dtmDateLastModified'],
      voters: json['voters'],
      attachments: json['attachments'],
      tasks: json['tasks'],
    );
  }
}

class getUserComplaint{
 
 Future<List<ComplaintModel>> getComplaints() async {
  
  var baseUrl = "https://10.0.2.2:5000/api/complaints/user/522";
  http.Response response = await http.get(
    Uri.parse(baseUrl),
    headers: {'Authorization': 'Bearer $token2'}
  );
  print(response.body);
  print(response.statusCode);
  print(response.reasonPhrase);
   print(response.headers);

  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body) as List;
     List<ComplaintModel> complaints = jsonData.map((element) =>
      ComplaintModel.fromJson(element)
    ).toList();
    return complaints;
  } else {
    throw response.statusCode;
  }
 }
}