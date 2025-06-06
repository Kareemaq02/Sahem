import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
import 'package:account/API/login_request.dart';

// ignore_for_file: avoid_print, unused_import

class EditInfo {
  final token2 = prefs!.getString('token');
  Future<String> updateAccount(
      String strNewUserName,
      String strNewEmail,
      String strNewPassword,
      String strNewPhoneNumber,
      String strNewLocation) async {
    String url = '${AppUrl.baseURL}/account/update';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token2',
      // 'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'strNewUserName': strNewUserName,
      'strNewEmail': strNewEmail,
      'strNewPhoneNumber': strNewPhoneNumber,
      'strNewPassword': strNewPassword,
      'strNewLocation': strNewLocation,
    };

    final String requestBody = json.encode(body);



    try {
      final response =
          await http.put(Uri.parse(url), headers: headers, body: requestBody);

      if (response.statusCode == 200) {
        print('Account updated successfully.');

        return 'Account updated successfully.';
      } else {
        print('Failed to update account. Error code: ${response.statusCode}');

        throw 'Failed to update account. Error code: ${response.statusCode}';
      }
    } catch (e) {
      print('Exception: $e');

      throw 'Exception: $e';
    }
  }
}
