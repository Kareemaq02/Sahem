// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_request.dart';

class EditInfo{

var token3="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFidXJ1bW1hbm4iLCJmaXJzdE5hbWUiOiJydWJhIiwibGFzdE5hbWUiOiJhYnVydW1tYW4iLCJwaG9uZU51bWJlciI6IjA3OTg5ODk5OTkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2OTAxODI2NzIsImV4cCI6MTY5Mjc3NDY3MiwiaWF0IjoxNjkwMTgyNjcyfQ.jMq9-vk97jJwzQ0PXRoDb5LoOD2fQxIo9B061-Hm3tI";


Future<String> updateAccount(String strNewUserName, String strNewEmail,
    String strNewPassword, String strNewPhoneNumber, String strNewLocation) async {
  String url = 'https://10.0.2.2:5000/api/account/update';

  Map<String, String> headers = {
    'Authorization': 'Bearer $token3',
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
    final response = await http.put(Uri.parse(url), headers: headers, body: requestBody);

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