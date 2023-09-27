import 'dart:convert';
import 'package:account/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';

class TeamBusyDatesRequest {
  final userToken = prefs!.getString('token');
  Future<List<DateTimeRange>> getDates(int teamId) async {
    var baseUrl = "${AppUrl.baseURL}teams/busydates/$teamId";
    http.Response response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as List;

      List<DateTimeRange> ranges = jsonData
          .map((e) => DateTimeRange(
              start: DateTime.parse(e["dtmStartDate"]),
              end: DateTime.parse(e["dtmEndDate"])))
          .toList();

      return ranges;
    } else {
      throw Exception('Failed to load Dates.');
    }
  }
}
