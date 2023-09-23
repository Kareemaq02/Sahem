import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
// ignore_for_file: avoid_print

// ignore_for_file: non_constant_identifier_names


class RateComplaint {
   final token2 = prefs!.getString('token');

  Future<dynamic> rateRequest(var complaintId,double rate) async {
    try {
    
      http.Response response = await http.post(
        Uri.parse("${AppUrl.baseURL}/tasks/rate/$complaintId?decRating=$rate"),
        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token2'
        },
      );

      if (response.statusCode == 200) {
        print('rated successful');
        return response.statusCode;
      } else {
        print('rated failed');
        return response.statusCode;
      }
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }
}