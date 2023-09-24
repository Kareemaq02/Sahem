import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
import 'package:account/Utils/TeamMembers.dart';
// ignore_for_file: file_names


class TaskDetails {
  int intTaskID;
  String dtmCreatedDate;
  String dtmFinishedDate;
  String dtmScheduledDate;
  String dtmDeadlineDate;
  String dtmLastModifiedDate;
  String dtmActivatedDate;
  double decUserRating;
  double decCost;
  String strComment;
  String strTypeNameAr;
  String strTypeNameEn;
  String strTaskStatus;
  String strAdminFirstName;
  String strAdminLastName;
  List<TeamMember> workersList;
  List<String> lstMedia;

  TaskDetails({
    required this.intTaskID,
    required this.dtmCreatedDate,
    required this.dtmFinishedDate,
    required this.dtmScheduledDate,
    required this.dtmDeadlineDate,
    required this.dtmLastModifiedDate,
    required this.dtmActivatedDate,
    required this.decUserRating,
    required this.decCost,
    required this.strComment,
    required this.strTypeNameAr,
    required this.strTypeNameEn,
    required this.strTaskStatus,
    required this.strAdminFirstName,
    required this.strAdminLastName,
    required this.workersList,
    required this.lstMedia,
  });

  factory TaskDetails.fromJson(Map<String, dynamic> json) {
    return TaskDetails(
      intTaskID: json['taskID'],
      dtmCreatedDate: json['createdDate'],
      dtmFinishedDate: json['finishedDate'],
      dtmScheduledDate: json['scheduledDate'],
      dtmDeadlineDate: json['deadlineDate'],
      dtmLastModifiedDate: json['lastModifiedDate'],
      dtmActivatedDate: json['activatedDate'],
      decUserRating: json['decUserRating'],
      decCost: json['decCost'],
      strComment: json['strComment'],
      strTypeNameAr: json['strTypeNameAr'],
      strTypeNameEn: json['strTypeNameEn'],
      strTaskStatus: json['strTaskStatus'],
      strAdminFirstName: json['strAdminFirstName'],
      strAdminLastName: json['strAdminLastName'],
      workersList: List<TeamMember>.generate(
        json['workersList'].length,
        (index) => TeamMember.fromJson(json['workersList'][index]),
      ),
      lstMedia: json['lstMedia'] != null
          ? List<String>.from(
              json['lstMedia'].map((map) => map['Data'].toString()))
          : List.empty(),
    );
  }
}

class TaskDetailsRequest {
  final userToken = prefs!.getString('token');
  Future<TaskDetails> getTaskDetails(int taskId) async {
    var baseUrl = "${AppUrl.baseURL}tasks/details/$taskId";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return TaskDetails.fromJson(jsonData);
    } else {
      throw Exception('Failed to load Task details');
    }
  }
}
