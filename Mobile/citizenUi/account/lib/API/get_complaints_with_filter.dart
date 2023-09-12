import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
import 'package:account/API/login_request.dart';


Future<List<dynamic>> getFilteredComplaints(
  List<int> statusIDs,
  List<int> complaintTypeIDs,
  lat ,
  lng
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
      '${AppUrl.baseURL}/complaints/general?pageSize=10&pageNumber=2&intDistance=30&userLat=$lat&userLng=$lng'
      '$statusIDsString'
      '$complaintTypeIDsString';

  http.Response response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token2',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> complaints = json.decode(response.body);
    return complaints;

  } else if (response.statusCode == 400) {
    throw ("restart the app");
  } else {
    throw (
        'Failed to get complaints. Status code: ${response.statusCode}');
  }
}

