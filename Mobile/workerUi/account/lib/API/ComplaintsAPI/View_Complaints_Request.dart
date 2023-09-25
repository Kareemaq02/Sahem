import 'dart:convert';
import 'package:account/Repository/urls.dart';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Utils/LatLng.dart';

// ignore_for_file: file_names

class ComplaintModel {
  int intComplaintId;
  String? strUserName;
  String strFirstName;
  String strLastName;
  String dtmDateCreated;
  String dtmDateFinished;
  int intTypeId;
  String strComplaintTypeEn;
  String strComplaintTypeAr;
  String strComment;
  int intStatusId;
  String strStatus;
  int intPrivacyId;
  String strPrivacyAr;
  String strPrivacyEn;
  int intVoted;
  int intVotersCount;
  LatLng latlng;
  double decPriority;
  List<String> lstMedia;

  ComplaintModel({
    required this.intComplaintId,
    required this.strUserName,
    required this.strFirstName,
    required this.strLastName,
    required this.dtmDateCreated,
    required this.dtmDateFinished,
    required this.intTypeId,
    required this.strComplaintTypeEn,
    required this.strComplaintTypeAr,
    required this.strComment,
    required this.intStatusId,
    required this.strStatus,
    required this.intPrivacyId,
    required this.strPrivacyAr,
    required this.strPrivacyEn,
    required this.intVoted,
    required this.intVotersCount,
    required this.latlng,
    required this.decPriority,
    required this.lstMedia,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      intComplaintId: json['intComplaintId'],
      strUserName: json['strUserName'],
      strFirstName: json['strFirstName'] ?? "",
      strLastName: json['strLastName'] ?? "",
      dtmDateCreated: json['dtmDateCreated'],
      dtmDateFinished: json['dtmDateFinished'],
      intTypeId: json['intTypeId'] ?? 0,
      strComplaintTypeEn: json['strComplaintTypeEn'],
      strComplaintTypeAr: json['strComplaintTypeAr'],
      strComment: json['strComment'],
      intStatusId: json['intStatusId'] ?? 0,
      strStatus: json['strStatus'],
      intPrivacyId: json['intPrivacyId'],
      strPrivacyAr: json['strPrivacyAr'],
      strPrivacyEn: json['strComplaintTypeEn'],
      intVoted: json['intVoted'],
      intVotersCount: json['intVotersCount'],
      latlng:
          LatLng(lat: json['latLng']['decLat'], lng: json['latLng']['decLng']),
      decPriority: json['decPriority']?.toDouble() ?? 0.0,
      lstMedia: json['lstMedia'] != null
          ? List<String>.from(
              json['lstMedia'].map((map) => map['data'].toString()))
          : List.empty(),
    );
  }
}

class PendingComplaints {
  final userToken = prefs!.getString('token');
  Future<List<ComplaintModel>> fetchPendingComplaints(int pageNumber) async {
    final response = await http.get(
      Uri.parse(
          "${AppUrl.baseURL}complaints?pageSize=10&pageNumber=$pageNumber&lstComplaintStatusIds=1&blnIncludePictures=true"),
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
      throw Exception('Failed to fetch Tasks');
    }
  }
}
