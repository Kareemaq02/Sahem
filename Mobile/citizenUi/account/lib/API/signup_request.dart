import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import '../Screens/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';

// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously




class UserSignup{


void signup(String username,String phone,String password,
String firstName,String lastName,String email,String  nationalId,String passportNumber,
String registrationNumber,String nationalIDNumber,BuildContext context) async {

  print(username + phone  + password + email +nationalId + firstName + lastName +nationalIDNumber  );

  print(registrationNumber);
    try{
      HttpOverrides.global = MyHttpOverrides();
      //registrationNumber='666/555';
      //nationalIdNumber=  'ABC12345';
     
      
       Response response = await  http.post(
        
        Uri.parse('${AppUrl.baseURL}/account/register'),
        headers: {
          'Content-Type': 'application/json',},
          

        body:jsonEncode({
        
        "strUsername": username,
        "strPhonenumber": phone,
        "strPassword": password,
        "strFirstName": firstName,
        "strLastName": lastName,
        "strEmail":email,
        "strNationalId": nationalId,
        "strPassportNumber": passportNumber,
        "strRegistrationNumber": registrationNumber,
        "strNationalIdNumber": nationalIDNumber,
        }),
      
      );
   print(response.body);
   print(response.headers );
   print(response.reasonPhrase);
    print(response.statusCode);
    if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    print(response.body);

    var userName = jsonResponse['strUserName'];
    var token1 = jsonResponse['strToken'];
    var fName = jsonResponse['strFirstName'];
    var lName = jsonResponse['strLastName'];
    print('Signup successful. Welcome, $fName $lName!');
     Navigator.push(context,MaterialPageRoute(builder: (context) => const XDLogin()),);

  } else {
    print('Signup failed. Status code: ${response.statusCode}');
  }
} catch (e) {
  print('Error occurred while registering: $e');
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