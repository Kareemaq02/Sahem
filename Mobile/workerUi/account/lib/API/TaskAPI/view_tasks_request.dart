import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;

class TaskModel {
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
  List<WorkersList> workersList;
  List<dynamic> lstMedia;

  TaskModel({
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
    required this.workersList,
    required this.lstMedia,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Parse the JSON and create a TaskModel instance
    return TaskModel(
      taskId: json['taskID'],
      createdDate: json['createdDate'],
      finishedDate: json['finishedDate'],
      scheduledDate: json['scheduledDate'],
      deadlineDate: json['deadlineDate'],
      lastModifiedDate: json['lastModifiedDate'],
      activatedDate: json['activatedDate'],
      decUserRating: json['decUserRating'],
      decCost: json['decCost'],
      strComment: json['strComment'],
      strTypeNameAr: json['strTypeNameAr'],
      strTypeNameEn: json['strTypeNameEn'],
      strTaskStatus: json['strTaskStatus'],
      strAdminFirstName: json['strAdminFirstName'],
      strAdminLastName: json['strAdminLastName'],
      workersList: List<WorkersList>.from(
        json['workersList'].map((x) => WorkersList.fromJson(x)),
      ),
      lstMedia: List<dynamic>.from(json['lstMedia']),
    );
  }
}

class WorkersList {
  int intId;
  String strFirstName;
  String strLastName;
  bool isLeader;

  WorkersList({
    required this.intId,
    required this.strFirstName,
    required this.strLastName,
    required this.isLeader,
  });
  factory WorkersList.fromJson(Map<String, dynamic> json) {
    return WorkersList(
      intId: json['intId'],
      strFirstName: json['strFirstName'],
      strLastName: json['strLastName'],
      isLeader: json['isLeader'],
    );
  }
}

class WorkerTask {
  final userToken = prefs!.getString('token');
  Future<List<dynamic>> fetchUserTasks() async {
    final response = await http.get(
        Uri.parse("https://10.0.2.2:5000/api/tasks/loggedInWorker"),
        headers: {
          'Authorization': 'Bearer $userToken',
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body.toString());
    } else {
      throw Exception('Failed to fetch Tasks');
    }
  }

  Future<List<TaskModel>> getWorkerTasksDetails(var id) async {
    var baseUrl = "https://10.0.2.2:5000/api/tasks/details/$id";

    http.Response response = await http.get(Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $userToken'});

    if (response.statusCode == 200) {
      //print(response.body);
      var jsonData = json.decode(response.body) as Map<String, dynamic>;
      TaskModel task = TaskModel.fromJson(jsonData);
      return [task];
    } else {
      throw Exception('JSON data is not in the expected format.');
    }
  }

  Future<List<dynamic>> fetchStatus() async {
    final response = await http.get(
        Uri.parse("https://10.0.2.2:5000/api/tasks/status/list"),
        headers: {
          'Authorization': 'Bearer $userToken',
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body.toString());
    } else {
      throw Exception('Failed to fetch complaints');
    }
  }
}
