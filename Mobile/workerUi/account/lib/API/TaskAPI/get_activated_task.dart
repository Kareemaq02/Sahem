import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
// ignore_for_file: file_names

int activatedStatus = 0;

class ActivatedTaskModel {
  int taskId;
  String deadlineDate;
  String activatedDate;
  String strComment;
  String strTypeNameAr;
  String strTypeNameEn;
  LatLng latLng;
  List<LstMedia> lstMedia;
  bool blnIsLeader;

  ActivatedTaskModel({
    required this.taskId,
    required this.deadlineDate,
    required this.activatedDate,
    required this.strComment,
    required this.strTypeNameAr,
    required this.strTypeNameEn,
    required this.latLng,
    required this.lstMedia,
    required this.blnIsLeader,
  });

  factory ActivatedTaskModel.fromJson(Map<String, dynamic> json) {
    return ActivatedTaskModel(
      taskId: json['taskID'],
      deadlineDate: json['deadlineDate'],
      activatedDate: json['activatedDate'],
      strComment: json['strComment'] ?? "",
      strTypeNameAr: json['strTypeNameAr'],
      strTypeNameEn: json['strTypeNameEn'],
      latLng: LatLng.fromJson(json['latLng']),
      lstMedia: (json['lstMedia'] as List)
          .map((media) => LstMedia.fromJson(media))
          .toList(),
      blnIsLeader: json['blnIsLeader'],
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
  factory LatLng.fromJson(Map<String, dynamic> json) {
    return LatLng(
      decLat: json['decLat'],
      decLng: json['decLng'],
    );
  }
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

class ActivatedTask {
  final userToken = prefs!.getString('token');

  Future<ActivatedTaskModel> getActivatedTask() async {
    var baseUrl = "${AppUrl.baseURL}tasks/active";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );
    if (response.statusCode == 400) {
      activatedStatus = 400;
    }
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return ActivatedTaskModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load Task details');
    }
  }
}
