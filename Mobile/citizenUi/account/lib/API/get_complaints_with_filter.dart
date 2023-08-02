import 'package:account/API/map_complaints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<List<ComplaintModel2>> getComplaintsByLocation(int statusID,int complaintTypeID,DateTime date) async {
  String token2='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lIiwiZmlyc3ROYW1lIjoiZmlyc3QiLCJsYXN0TmFtZSI6Imxhc3QiLCJwaG9uZU51bWJlciI6IjAxMjM0NTY3ODkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2ODg2NTEwMDYsImV4cCI6MTY5MTI0MzAwNiwiaWF0IjoxNjg4NjUxMDA2fQ.NJPnHG4WNtnelTqJm7KNGY4Jf6j3j7XZ5zOMHpALDBM';

  final url = 'https://10.0.2.2:5000/api/complaints?pageSize=10&pageNumber=2&lstComplaintStatusIds=$statusID&lstComplaintStatusIds=$statusID&lstComplaintTypeIds=$complaintTypeID&lstComplaintTypeIds=$complaintTypeID&dtmDateCreated=$date';
 http.Response response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token2',
    },
  );
  
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      List<ComplaintModel2> complaints = jsonData
          .map((complaintData) => ComplaintModel2.fromJson(complaintData))
          .toList();
          print(complaints.length);
      return complaints;
    } else {
      throw Exception('Failed to get complaints. Status code: ${response.statusCode}');
    }
  }
