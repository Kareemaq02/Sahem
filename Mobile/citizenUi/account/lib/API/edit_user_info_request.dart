// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_request.dart';


class EditInfo{

Future<void> updateAccount(String strNewUserName,String strNewEmail,
String strNewPassword,String strNewPhoneNumber,String strNewLocation) async {
  String url = 'https://10.0.2.2:5000/api/account/update';

  Map<String, String> headers = {
    'Authorization': 'Bearer $token2'
  };

  Map<String, dynamic> body = {
    "strNewUserName":strNewUserName ,
    "strNewEmail": strNewEmail,
    "strNewPhoneNumber": strNewPhoneNumber,
    "strOldPassword": "Pass@123",
    "strNewPassword":strNewPassword ,
    "strNewLocation": strNewLocation
  };

  String requestBody = json.encode(body);

  try {
    final response = await http.put(Uri.parse(url), headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      // Successful request
      print('Account updated successfully.');
    } else {
      // Error occurred
      print('Failed to update account. Error code: ${response.statusCode}');
    }
  } catch (e) {
    
    print('Exception: $e');
  }
}

}