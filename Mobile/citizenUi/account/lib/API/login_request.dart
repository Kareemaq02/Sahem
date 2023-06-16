

// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/login.dart';
import '../Screens/public_feed.dart';




late String token2;

class UserLogin{
  

  Future<int> login(String email, String password,BuildContext context) async {

    print(email);
    print(password);
  try {
    HttpOverrides.global = MyHttpOverrides();
    Response response = await post(
      Uri.parse('https://10.0.2.2:5000/api/account/login/'),
      headers: <String, String>{
        "Content-type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "strLogin":"aburummann" ,
        "strPassword": password,
      }),
    );
    //print(response.body);
    responseMessage=response.body;
    //print(responseMessage);
    print(response.statusCode);
    print(response.headers);

    if (response.statusCode == 200) {
      token2 = jsonDecode(response.body);
      print(token2);
      print('Login successful');

      // Save the token in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token2);

       Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const XDPublicFeed1(),
        ),
      );

      final userData = await fetchUserData(token2);
      print(userData);
      return response.statusCode;
    } 
    else {
      print('Login failed');
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
    return 0;
    
  }
}

// Fetching user data using the token
Future<Map<String, dynamic>> fetchUserData(String token) async {
  try {
    final response = await http.get(
      Uri.parse('https://10.0.2.2:5000/api/account/userdata/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch user data');
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}
  


}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}