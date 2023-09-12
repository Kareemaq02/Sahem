// ignore_for_file: avoid_print, unused_import

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../login_request.dart';

class EditInfo {
  Future<String> updateAccount(
      String strNewUserName,
      String strNewEmail,
      String strNewPassword,
      String strNewPhoneNumber,
      String strNewLocation) async {
    String url = 'https://10.0.2.2:5000/api/account/update';

    Map<String, String> headers = {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      "strNewUserName": strNewUserName,
      "strNewEmail": strNewEmail,
      "strNewPhoneNumber": strNewPhoneNumber,
      "strOldPassword": "Pass@123",
      "strNewPassword": strNewPassword,
      "strNewLocation": strNewLocation
    };

    String requestBody = json.encode(body);

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
