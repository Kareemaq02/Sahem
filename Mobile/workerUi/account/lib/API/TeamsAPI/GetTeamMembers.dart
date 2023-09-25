import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
import 'package:account/Utils/TeamMembers.dart';

class GetTeamMembersRequest {
  
  final userToken = prefs!.getString('token');

  Future<List<TeamMember>> getTeamMembers(int teamId) async {
    var baseUrl = "${AppUrl.baseURL}teams/$teamId";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var lstWorkers = jsonData["lstWorkers"] as List;
      var formattedList =
          lstWorkers.map((e) => TeamMember.fromJson(e)).toList();
      formattedList.add(
        TeamMember(
            jsonData["intTeamLeaderId"],
            "${jsonData["strTeamLeaderFirstNameAr"]} ${jsonData["strTeamLeaderLastNameAr"]}",
            true),
      );
      return formattedList;
    } else {
      throw Exception('Failed to load complaint types');
    }
  }


   Future<List<TeamMember>> getTeamMembersByLeader(int leaderId) async {
    var baseUrl = "${AppUrl.baseURL}teams/$leaderId";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var lstWorkers = jsonData["lstWorkers"] as List;
      var formattedList =
          lstWorkers.map((e) => TeamMember.fromJson(e)).toList();
      formattedList.add(
        TeamMember(
            jsonData["intTeamLeaderId"],
            "${jsonData["strTeamLeaderFirstNameAr"]} ${jsonData["strTeamLeaderLastNameAr"]}",
            true),
      );
      return formattedList;
    } else {
      throw Exception('Failed to load complaint types');
    }
  }
}
