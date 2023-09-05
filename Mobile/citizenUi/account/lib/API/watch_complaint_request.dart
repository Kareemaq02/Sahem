import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:account/API/login_request.dart';

class WatchComplaint {
  Future<void> watchRequest(var complaintId) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
            "https://10.0.2.2:5000/api/complaints/addToWatchlist/$complaintId"),
        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token2'
        },
      );

      if (response.statusCode == 200) {
        print('watched successful');

      } else {
        print('watch failed');
      }
    } catch (e) {
      print(e.toString());

    }
  }

  Future<void> unwatchRequest(var complaintId) async {
    try {
      http.Response response = await http.delete(
        Uri.parse(
            "https://10.0.2.2:5000/api/complaints/removeFromWatchList/$complaintId"),
        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token2'
        },
      );

      if (response.statusCode == 200) {
        print('unwatched successful');
      } else {
        print('un watch failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
