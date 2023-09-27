import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Utils/LatLng.dart';
// Import the necessary class

class TaskModel {
  int taskId;
  int intTeamId;
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
  List<dynamic> lstMediaAfter;
  List<LstMediaBefore> lstMediaBefore;

  TaskModel({
    required this.taskId,
    required this.intTeamId,
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
    required this.lstMediaAfter,
    required this.lstMediaBefore,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskID'],
      intTeamId: json['intTeamId'],
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
      workersList: (json['workersList'] as List<dynamic>)
          .map((x) => WorkersList.fromJson(x as Map<String, dynamic>))
          .toList(),
      lstMediaAfter: json['lstMediaAfter'],
      lstMediaBefore: (json['lstMediaBefore'] as List<dynamic>)
          .map((x) => LstMediaBefore.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LstMediaBefore {
  int intComplaintId;
  dynamic data;
  bool blnIsVideo;
  LatLng decLatLng;
  Region region;

  LstMediaBefore({
    required this.intComplaintId,
    required this.data,
    required this.blnIsVideo,
    required this.decLatLng,
    required this.region,
  });
  factory LstMediaBefore.fromJson(Map<String, dynamic> json) {
    return LstMediaBefore(
        intComplaintId: json['intComplaintId'],
        data: json['data'],
        blnIsVideo: json['blnIsVideo'],
        decLatLng: LatLng(
          lat: json['decLatLng']['decLat'],
          lng: json['decLatLng']['decLng'],
        ),
        region: Region(
          strRegionEn: json['region']['strRegionEn'],
          strRegionAr: json['region']['strRegionAr'],
        ));
  }
}

class WorkersList {
  int intId;
  String strFirstName;
  String strLastName;
  String? strFirstNameAr;
  String? strLastNameAr;
  bool isLeader;
  double decRating;

  WorkersList({
    required this.intId,
    required this.strFirstName,
    required this.strLastName,
    required this.strFirstNameAr,
    required this.strLastNameAr,
    required this.isLeader,
    required this.decRating,
  });

  factory WorkersList.fromJson(Map<String, dynamic> json) {
    return WorkersList(
      intId: json['intId'],
      strFirstName: json['strFirstName'],
      strLastName: json['strLastName'],
      strFirstNameAr: json['strFirstNameAr'],
      strLastNameAr: json['strLastNameAr'],
      isLeader: json['isLeader'],
      decRating: json['decRating'],
    );
  }
}

class Region {
  String strRegionEn;
  String strRegionAr;

  Region({
    required this.strRegionEn,
    required this.strRegionAr,
  });
}

class WorkerTask {
  final userToken = prefs!.getString('token');
  Future<List<dynamic>> fetchUserTasks() async {
    final response = await http.get(
        Uri.parse("https://10.0.2.2:5000/api/tasks/loggedInWorker"),
        headers: {
          'Authorization': 'Bearer $userToken',
        });

    var responseData = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      return responseData;
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
