import 'dart:convert';
import 'package:account/Utils/Team.dart';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';

class TeamByLeaderRequest {
  final userToken = prefs!.getString('token');
  Future<Team> getTeam(int leaderId) async {
    var baseUrl = "${AppUrl.baseURL}teams/leader/$leaderId";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return Team(
        jsonData["intTeamId"],
        "${jsonData["strTeamLeaderFirstNameAr"]} ${jsonData["strTeamLeaderLastNameAr"]}",
      );
    } else {
      throw Exception('Failed to load complaint types');
    }
  }
}
