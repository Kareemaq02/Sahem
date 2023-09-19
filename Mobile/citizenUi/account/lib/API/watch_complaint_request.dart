import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';

// ignore_for_file: avoid_print



class WatchComplaint {
   final token2 = prefs!.getString('token');
  Future<void> watchRequest(var complaintId) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
            "${AppUrl.baseURL}/complaints/addToWatchlist/$complaintId"),
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
            "${AppUrl.baseURL}/complaints/removeFromWatchList/$complaintId"),
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
