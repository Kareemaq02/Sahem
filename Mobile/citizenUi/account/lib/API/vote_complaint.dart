// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:account/API/login_request.dart';
import 'package:http/http.dart' as http;


class VoteComplaint{
  
//var token22="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFidXJ1bW1hbm4iLCJmaXJzdE5hbWUiOiJydWJhIiwibGFzdE5hbWUiOiJhYnVydW1tYW4iLCJwaG9uZU51bWJlciI6IjA3OTg5ODk5OTkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2ODk2NzczNTgsImV4cCI6MTY5MjI2OTM1OCwiaWF0IjoxNjg5Njc3MzU4fQ.SQ511QbYWlsd7L2yvulPxWUn3qSzUtw67y6WddvFIMk";
 Future<int?>sendVoteRequest(var complaintId) async {
  try {
    String token2='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lIiwiZmlyc3ROYW1lIjoiZmlyc3QiLCJsYXN0TmFtZSI6Imxhc3QiLCJwaG9uZU51bWJlciI6IjAxMjM0NTY3ODkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2ODg2NTEwMDYsImV4cCI6MTY5MTI0MzAwNiwiaWF0IjoxNjg4NjUxMDA2fQ.NJPnHG4WNtnelTqJm7KNGY4Jf6j3j7XZ5zOMHpALDBM';
    http.Response response = await http.post(
      Uri.parse("https://10.0.2.2:5000/api/complaints/vote/$complaintId"),
      headers: <String, String>{
        "Content-type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token2'
      },
     
    
    );
  print("Voteeeeeeeeeeeeeeeeeeeeeee");
    print(response.body);
    print(response.statusCode);
    print(response.reasonPhrase);
    print(response.headers);
     print(complaintId);

    if (response.statusCode == 200) {
      token2 = jsonDecode(response.body);
      print(token2);
      print('Voted successful');
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('token', token2);

      return response.statusCode;
    } 
    else {
      print('Vote failed');
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
    return 0;
    
  }

}

Future<int?>RemoveVoteRequest(var complaintId) async {
  try {
    String token2='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lIiwiZmlyc3ROYW1lIjoiZmlyc3QiLCJsYXN0TmFtZSI6Imxhc3QiLCJwaG9uZU51bWJlciI6IjAxMjM0NTY3ODkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2ODg2NTEwMDYsImV4cCI6MTY5MTI0MzAwNiwiaWF0IjoxNjg4NjUxMDA2fQ.NJPnHG4WNtnelTqJm7KNGY4Jf6j3j7XZ5zOMHpALDBM';
    http.Response response = await http.post(
      Uri.parse("https://10.0.2.2:5000/api/complaints/votedown/$complaintId"),
      headers: <String, String>{
        "Content-type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token2'
      },
     
    
    );
    print(" nottt    Voteeeeeeeeeeeeeeeeeeeeeee");
    print(response.body);
    print(response.statusCode);
    print(response.reasonPhrase);
    print(response.headers);
     print(complaintId);

    if (response.statusCode == 200) {
      token2 = jsonDecode(response.body);
      print(token2);
      print('Voted successful');
    

      return response.statusCode;
    } 
    else {
      print('Vote failed');
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
    return 0;
    
  }

}

}
