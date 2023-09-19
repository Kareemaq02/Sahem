import 'dart:convert';
import 'package:http/http.dart' as http;
import '../login_request.dart';import 'package:account/main.dart';
// ignore_for_file: file_names


// ignore_for_file: avoid_print, unused_import


class EditInfo {
    final userToken = prefs!.getString('token');
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
