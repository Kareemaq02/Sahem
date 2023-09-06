import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:account/API/login_request.dart';
// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, avoid_print

//import 'package:account/API/login_request.dart';

class ComplaintModel {
  int intComplaintId;
  String strUserName;
  DateTime dtmDateCreated;
  DateTime dtmDateFinished;
  String strComplaintTypeEn;
  String strComplaintTypeAr;
  String strComment;
  String strStatus;
  int intPrivacyId;
  String strPrivacyAr;
  String strPrivacyEn;
  int intVotersCount;
  int intVoted;
  LatLng latLng;
  List<LstMedia> lstMedia;

  ComplaintModel({
    required this.intComplaintId,
    required this.strUserName,
    required this.dtmDateCreated,
    required this.dtmDateFinished,
    required this.strComplaintTypeEn,
    required this.strComplaintTypeAr,
    required this.strComment,
    required this.strStatus,
    required this.intPrivacyId,
    required this.strPrivacyAr,
    required this.strPrivacyEn,
    required this.intVotersCount,
    required this.intVoted,
    required this.latLng,
    required this.lstMedia,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      intComplaintId: json['intComplaintId'],
      strUserName: json['strUserName'],
      dtmDateCreated: DateTime.parse(json['dtmDateCreated']),
      dtmDateFinished: DateTime.parse(json['dtmDateFinished']),
      strComplaintTypeEn: json['strComplaintTypeEn'],
      strComplaintTypeAr: json['strComplaintTypeAr'],
      strComment: json['strComment'],
      strStatus: json['strStatus'],
      intPrivacyId: json['intPrivacyId'],
      strPrivacyAr: json['strPrivacyAr'],
      strPrivacyEn: json['strPrivacyEn'],
      intVotersCount: json['intVotersCount'],
      intVoted: json['intVoted'],
      latLng: LatLng(
        decLat: json['latLng']['decLat'],
        decLng: json['latLng']['decLng'],
      ),
      lstMedia: (json['lstMedia'] as List<dynamic>)
          .map((media) => LstMedia.fromJson(media))
          .toList(),
    );
  }
}

class LatLng {
  double decLat;
  double decLng;

  LatLng({
    required this.decLat,
    required this.decLng,
  });
}

class LstMedia {
  String data;
  bool isVideo;

  LstMedia({
    required this.data,
    required this.isVideo,
  });

  factory LstMedia.fromJson(Map<String, dynamic> json) {
    return LstMedia(
      data: json['data'],
      isVideo: json['isVideo'],
    );
  }
}

class getUserComplaint {
  Future<List<dynamic>> fetchComplaints() async {
    final response = await http
        .get(Uri.parse("https://10.0.2.2:5000/api/complaints/user"), headers: {
      'Authorization': 'Bearer $token2',
    });

    if (response.statusCode == 200) {
      print("ok");

      return jsonDecode(response.body.toString());
    } else {
      throw Exception('Failed to fetch complaints');
    }
  }

  Future<List<ComplaintModel>> getComplaintById(String complaintId) async {
    var baseUrl = "https://10.0.2.2:5000/api/complaints/$complaintId";

    http.Response response = await http
        .get(Uri.parse(baseUrl), headers: {'Authorization': 'Bearer $token2'});

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as Map<String, dynamic>;
      ComplaintModel complaint = ComplaintModel.fromJson(jsonData);
      return [complaint];
    } else {
      throw response.statusCode;
    }
  }

  Future<List<dynamic>> fetchStatus() async {
    final response = await http.get(
        Uri.parse("https://10.0.2.2:5000/api/complaints/status/list"),
        headers: {
          'Authorization': 'Bearer $token2',
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body.toString());
    } else {
      throw Exception('Failed to fetch complaints');
    }
  }
}
