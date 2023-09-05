import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:account/API/login_request.dart';


class WatchComplaint {
  Future<int?> watchRequest(var complaintId) async {
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
        token2 = jsonDecode(response.body);
   
        print('watched successful');

        return response.statusCode;
      } else {
        print('watch failed');
        return response.statusCode;
      }
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

   Future<int?> unwatchRequest(var complaintId) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
            "https://10.0.2.2:5000/api/complaints/delete/$complaintId"),
        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token2'
        },
      );

      if (response.statusCode == 200) {
        token2 = jsonDecode(response.body);

        print('watched successful');

        return response.statusCode;
      } else {
        print('watch failed');
        return response.statusCode;
      }
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }
}
