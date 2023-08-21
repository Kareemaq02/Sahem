import 'package:account/API/login_request.dart';
import 'package:account/API/map_complaints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<ComplaintModel2>> getFilteredComplaints(
  List<int> statusIDs,
  List<int> complaintTypeIDs,
) async {
  String statusIDsString = '';
  for (int id in statusIDs) {
    statusIDsString += '&lstComplaintStatusIds=$id';
  }
  String complaintTypeIDsString = '';
  for (int id in complaintTypeIDs) {
    complaintTypeIDsString += '&lstComplaintTypeIds=$id';
  }

  final url =
      'https://10.0.2.2:5000/api/complaints?pageSize=10&pageNumber=2'
      '$statusIDsString'
      '$complaintTypeIDsString';

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
    throw Exception(
        'Failed to get complaints. Status code: ${response.statusCode}');
  }
}
