// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
import 'package:account/API/login_request.dart';

// ignore_for_file: avoid_print

class VoteComplaint {
  Future<dynamic> sendVoteRequest(var complaintId, context) async {
    try {
      http.Response response = await http.post(
        Uri.parse("${AppUrl.baseURL}/complaints/vote/$complaintId"),
        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token2'
        },
      );

      if (response.statusCode == 200) {
        print('Voted successful');

        return response.statusCode;
      } else {
        print('Vote failed');
        return response.statusCode;
      }
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<dynamic> removeVoteRequest(var complaintId, context) async {
    // final countProvider = Provider.of<CountProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse(
            "${AppUrl.baseURL}/complaints/voteremove/$complaintId"),
        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token2'
        },
      );

      if (response.statusCode == 200) {
        print('Voted removed successful');

        return response.statusCode;
      } else {
        print('Vote removed failed');
        return response.statusCode;
      }
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<dynamic> DownVoteRequest(var complaintId, context) async {
    try {
      http.Response response = await http.post(
        Uri.parse("${AppUrl.baseURL}/complaints/votedown/$complaintId"),
        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token2'
        },
      );

      if (response.statusCode == 200) {
        //   countProvider.updateCount(countProvider.count -1);
        print('Voted downed successful');

        return response.statusCode;
      } else {
        print('Vote downed failed');
        return response.statusCode;
      }
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }
}
