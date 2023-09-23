import 'dart:convert';
import 'package:account/Utils/Team.dart';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';

class AvailableTeamsRequest {
  final userToken = prefs!.getString('token');
  Future<List<Team>> getAvailableTeams(
      DateTime startDate, DateTime endDate) async {
    var baseUrl =
        "${AppUrl.baseURL}teams/available?startDate=$startDate&endDate=$endDate";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as List;
      return jsonData
          .map((element) => Team(element["intTeamId"],
              "${element["strTeamLeaderFirstNameAr"]} ${element["strTeamLeaderLastNameAr"]}"))
          .toList();
    } else {
      throw Exception('Failed to load complaint types');
    }
  }
}
