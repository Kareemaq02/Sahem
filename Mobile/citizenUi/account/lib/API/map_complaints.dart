// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, avoid_print, avoid_function_literals_in_foreach_calls
import 'dart:convert';
import 'package:http/http.dart' as http;

class ComplaintModel2 {
 
  int intComplaintId;
  String strUserName;
  DateTime dtmDateCreated;
  DateTime dtmDateFinished;
  int intTypeId;
  String strComplaintTypeEn;
  String strComplaintTypeAr;
  String strComment;
  int intStatusId;
  String strStatus;
  int intPrivacyId;
  String strPrivacyAr;
  String strPrivacyEn;
  int intVoted;
  int intVotersCount;
  LatLng1 latLng;
  double decPriority;

  ComplaintModel2({
    required this.intComplaintId,
    required this.strUserName,
    required this.dtmDateCreated,
    required this.dtmDateFinished,
    required this.intTypeId,
    required this.strComplaintTypeEn,
    required this.strComplaintTypeAr,
    required this.strComment,
    required this.intStatusId,
    required this.strStatus,
    required this.intPrivacyId,
    required this.strPrivacyAr,
    required this.strPrivacyEn,
    required this.intVoted,
    required this.intVotersCount,
    required this.latLng,
    required this.decPriority,
  });
 factory ComplaintModel2.fromJson(Map<String, dynamic> json) {
    return ComplaintModel2(
      intComplaintId: json['intComplaintId'],
      strUserName: json['strUserName'],
      dtmDateCreated: DateTime.parse(json['dtmDateCreated']),
      dtmDateFinished: DateTime.parse(json['dtmDateFinished']),
      intTypeId: json['intTypeId'],
      strComplaintTypeEn: json['strComplaintTypeEn'],
      strComplaintTypeAr: json['strComplaintTypeAr'],
      strComment: json['strComment'],
      intStatusId: json['intStatusId'],
      strStatus: json['strStatus'],
      intPrivacyId: json['intPrivacyId'],
      strPrivacyAr: json['strPrivacyAr'],
      strPrivacyEn: json['strPrivacyEn'],
      intVoted: json['intVoted'],
      intVotersCount: json['intVotersCount'],
      latLng: LatLng1(
        decLat: json['latLng']['decLat'],
        decLng: json['latLng']['decLng'],
      ),
      decPriority: json['decPriority'],
    );
  }
  
}
class LatLng1{
    double decLat=0.0;
    double decLng=0.0;

    LatLng1({
        required this.decLat,
        required this.decLng,
    });

}





class getUsersComplaint {
  final String apiUrl = "https://10.0.2.2:5000/api/complaints";
  

  Future<List<ComplaintModel2>> getComplaints() async {
       String token2='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lIiwiZmlyc3ROYW1lIjoiZmlyc3QiLCJsYXN0TmFtZSI6Imxhc3QiLCJwaG9uZU51bWJlciI6IjAxMjM0NTY3ODkiLCJ1c2VyVHlwZSI6InVzZXIiLCJuYmYiOjE2ODg2NTEwMDYsImV4cCI6MTY5MTI0MzAwNiwiaWF0IjoxNjg4NjUxMDA2fQ.NJPnHG4WNtnelTqJm7KNGY4Jf6j3j7XZ5zOMHpALDBM';
  var baseUrl = "https://10.0.2.2:5000/api/complaints";
  http.Response response = await http.get(
    Uri.parse(baseUrl),
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
}