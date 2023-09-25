import 'dart:convert';
import 'package:account/API/TaskAPI/view_tasks_request.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Repository/urls.dart';
import 'package:account/Utils/LatLng.dart';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;

class TaskEvaluationModel {
  int taskId;
  String? createdDate;
  String finishedDate;
  String scheduledDate;
  String deadlineDate;
  String lastModifiedDate;
  String activatedDate;
  double decUserRating;
  double decCost;
  String strComment;
  String strTypeNameAr;
  String strTypeNameEn;
  String strTaskStatus;
  String strAdminFirstName;
  String strAdminLastName;
  LatLng latLng;
  List<WorkersList> workersList;
  List<ComplaintImage> lstMedia;

  TaskEvaluationModel({
    required this.taskId,
    required this.createdDate,
    required this.finishedDate,
    required this.scheduledDate,
    required this.deadlineDate,
    required this.lastModifiedDate,
    required this.activatedDate,
    required this.decUserRating,
    required this.decCost,
    required this.strComment,
    required this.strTypeNameAr,
    required this.strTypeNameEn,
    required this.strTaskStatus,
    required this.strAdminFirstName,
    required this.strAdminLastName,
    required this.latLng,
    required this.workersList,
    required this.lstMedia,
  });

  factory TaskEvaluationModel.fromJson(Map<String, dynamic> json) {
    var requestLstMedia = json['lstMedia'] as List;
    return TaskEvaluationModel(
      taskId: json['taskID'],
      createdDate: json['createdDate'],
      finishedDate: json['finishedDate'],
      scheduledDate: json['scheduledDate'],
      deadlineDate: json['deadlineDate'],
      lastModifiedDate: json['lastModifiedDate'] ?? "",
      activatedDate: json['activatedDate'],
      decUserRating: json['decUserRating'] ?? 0.0,
      decCost: json['decCost'] ?? 0.0,
      strComment: json['strComment'] ?? "",
      strTypeNameAr: json['strTypeNameAr'],
      strTypeNameEn: json['strTypeNameEn'],
      strTaskStatus: json['strTaskStatus'],
      strAdminFirstName: json['strAdminFirstName'] ?? "",
      strAdminLastName: json['strAdminLastName'] ?? "",
      latLng: LatLng(
        lat: requestLstMedia.isNotEmpty
            ? requestLstMedia.first['decLatLng']['decLat']
            : 0.0,
        lng: requestLstMedia.isNotEmpty
            ? requestLstMedia.first['decLatLng']['decLng']
            : 0.0,
      ),
      workersList: List<WorkersList>.from(
        json['workersList'].map((x) => WorkersList.fromJson(x)),
      ),
      lstMedia: List<dynamic>.from(requestLstMedia)
          .map((e) => ComplaintImage(
              intComplaintId: e["intComplaintId"], base64Data: e["data"] ?? ""))
          .toList(),
    );
  }
}

class ComplaintImage {
  ComplaintImage({required this.intComplaintId, required this.base64Data});
  int intComplaintId;
  String base64Data;
}

class AdminTasksRequest {
  final userToken = prefs!.getString('token');
  Future<List<TaskEvaluationModel>> getAdminTasks(int pageNumber) async {
    final response = await http.get(
        Uri.parse(
            "${AppUrl.baseURL}tasks?pageSize=10&pageNumber=$pageNumber&lstTaskStatusIds=3&strAdmin=${getUserData().userName}"),
        headers: {
          'Authorization': 'Bearer $userToken',
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<TaskEvaluationModel> tasksList = jsonData.map((json) {
        return TaskEvaluationModel.fromJson(json);
      }).toList();

      return tasksList;
    } else {
      throw Exception('Failed to fetch Tasks');
    }
  }
}
