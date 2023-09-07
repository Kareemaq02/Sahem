import 'dart:convert';
import '../login_request.dart';
import 'package:http/http.dart' as http;

class LatLng {
  double lat;
  double lng;

  LatLng({required this.lat, required this.lng});
}

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
      strFirstName: json['strFirstName'],
      strLastName: json['strLastName'],
      dtmDateCreated: json['dtmDateCreated'],
      dtmDateFinished: json['dtmDateFinished'],
      intTypeId: json['intTypeId'],
      strComplaintTypeEn: json['strComplaintTypeEn'],
      strComplaintTypeAr: json['strComplaintTypeAr'],
      strComment: json['strComment'],
      intStatusId: json['intStatusId'],
      strStatus: json['strStatus'],
      intPrivacyId: json['intPrivacyId'],
      strPrivacyAr: json['strPrivacyAr'],
      strPrivacyEn: json['strComplaintTypeEn'],
      intVoted: json['intVoted'],
      intVotersCount: json['intVotersCount'],
      latlng:
          LatLng(lat: json['latLng']['decLat'], lng: json['latLng']['decLng']),
      decPriority: json['decPriority'],
      lstMedia: json['lstMedia'] != null
          ? List<String>.from(json['lstMedia'])
          : List.empty(),
    );
  }
}

class PendingComplaints {
  Future<List<ComplaintModel>> fetchPendingComplaints(int pageNumber) async {
    final response = await http.get(
      Uri.parse(
          "https://10.0.2.2:5000/api/complaints?pageSize=10&pageNumber=$pageNumber&lstComplaintStatusIds=1"),
      headers: {
        'Authorization': 'Bearer $token2',
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
