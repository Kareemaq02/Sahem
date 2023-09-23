import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';

class TeamMembersRating {
  TeamMembersRating(this.intId, this.decRating, this.strName, this.blnIsLeader);
  int intId;
  double decRating;
  String strName;
  bool blnIsLeader;

  factory TeamMembersRating.fromJson(Map<String, dynamic> json) {
    return TeamMembersRating(
        json['intWorkerId'] as int,
        json['decMemberRating'].toDouble(),
        '${json['strMemberFirstNameAr']} ${json['strMemberLastNameAr']}',
        false);
  }
}

class TeamAnalyticsModel {
  TeamAnalyticsModel({
    required this.intTeamId,
    required this.intTasksCount,
    required this.intTasksCompletedCount,
    required this.intTasksScheduledCount,
    required this.intTasksIncompleteCount,
    required this.intTasksWaitingEvaluationCount,
    required this.decTeamRatingAvg,
    required this.lstMembersAvgRating,
  });

  int intTeamId;
  int intTasksCount;
  int intTasksCompletedCount;
  int intTasksScheduledCount;
  int intTasksIncompleteCount;
  int intTasksWaitingEvaluationCount;
  double decTeamRatingAvg;
  List<TeamMembersRating> lstMembersAvgRating;

  factory TeamAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return TeamAnalyticsModel(
      intTeamId: json["intTeamId"],
      intTasksCount: json["intTasksCount"],
      intTasksCompletedCount: json["intTasksCompletedCount"],
      intTasksScheduledCount: json["intTasksScheduledCount"],
      intTasksIncompleteCount: json["intTasksIncompleteCount"],
      intTasksWaitingEvaluationCount: json["intTasksWaitingEvaluationCount"],
      decTeamRatingAvg: json["decTeamRatingAvg"].toDouble(),
      lstMembersAvgRating: List<TeamMembersRating>.from(
        json["lstMembersAvgRating"].map(
          (map) => TeamMembersRating.fromJson(map),
        ),
      ),
    );
  }
}

class TeamsAnalyticsRequest {
  final userToken = prefs!.getString('token');
  Future<TeamAnalyticsModel> getTeamsAnalytics(int teamId) async {
    var baseUrl = "${AppUrl.baseURL}teams/analytics/$teamId";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    var baseUrlLeader = "${AppUrl.baseURL}teams/$teamId";
    http.Response responseLeader = await http.get(
      Uri.parse(baseUrlLeader),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var analyticsObj = TeamAnalyticsModel.fromJson(jsonData);
      // Add leader from 2nd request
      var jsonDataLeader = json.decode(responseLeader.body);
      analyticsObj.lstMembersAvgRating.add(
        TeamMembersRating(
            jsonDataLeader["intTeamLeaderId"],
            0.0,
            "${jsonDataLeader["strTeamLeaderFirstNameAr"]} ${jsonDataLeader["strTeamLeaderLastNameAr"]}",
            true),
      );

      return analyticsObj;
    } else {
      throw Exception('Failed to load complaint types');
    }
  }
}
