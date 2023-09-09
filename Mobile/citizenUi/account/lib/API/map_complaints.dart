import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
import 'package:account/API/login_request.dart';
// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, avoid_print, avoid_function_literals_in_foreach_calls

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
  var baseUrl = "${AppUrl.baseURL}/complaints";
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