import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';

// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, avoid_print, avoid_function_literals_in_foreach_calls


class ComplaintModel2 {
  int intComplaintId;
  DateTime dtmDateFinished;
  String strAddress;
  int intTypeId;
  String strComplaintTypeEn;
  String strComplaintTypeAr;
  int intStatusId;
  String strStatusEn;
  String strStatusAr;
  LatLng1 latLng;
  List<MediaModel> lstMediaBefore;

  ComplaintModel2({
    required this.intComplaintId,
    required this.dtmDateFinished,
    required this.strAddress,
    required this.intTypeId,
    required this.strComplaintTypeEn,
    required this.strComplaintTypeAr,
    required this.intStatusId,
    required this.strStatusEn,
    required this.strStatusAr,
    required this.latLng,
    required this.lstMediaBefore,
  });

  factory ComplaintModel2.fromJson(Map<String, dynamic> json) {
    return ComplaintModel2(
      intComplaintId: json['intComplaintId'],
      dtmDateFinished: DateTime.parse(json['dtmDateFinished']),
      strAddress: json['strAddress'],
      intTypeId: json['intTypeId'],
      strComplaintTypeEn: json['strComplaintTypeEn'],
      strComplaintTypeAr: json['strComplaintTypeAr'],
      intStatusId: json['intStatusId'],
      strStatusEn: json['strStatusEn'],
      strStatusAr: json['strStatusAr'],
      latLng: LatLng1(
        decLat: json['latLng']['decLat'],
        decLng: json['latLng']['decLng'],
      ),
      lstMediaBefore: (json['lstMediaBefore'] as List<dynamic>)
          .map((mediaData) => MediaModel.fromJson(mediaData))
          .toList(),
    );
  }
}

class MediaModel {
  String data;
  bool isVideo;

  MediaModel({
    required this.data,
    required this.isVideo,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      data: json['data'],
      isVideo: json['isVideo'],
    );
  }
}

class LatLng1 {
  double decLat = 0.0;
  double decLng = 0.0;

  LatLng1({
    required this.decLat,
    required this.decLng,
  });
}

class getUsersComplaint {
  final token2 = prefs!.getString('token');
  final String apiUrl = '${AppUrl.baseURL}/complaints/completed/public/mapview';

  Future<List<ComplaintModel2>> getComplaints() async {
    http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token2',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      List<ComplaintModel2> complaints = jsonData
          .map((complaintData) => ComplaintModel2.fromJson(complaintData))
          .toList();
      print(complaints.length);
      return complaints;
    } else {
      throw Exception(
          'Failed to get complaints. Status code: ${response.statusCode}');
    }
  }
}

