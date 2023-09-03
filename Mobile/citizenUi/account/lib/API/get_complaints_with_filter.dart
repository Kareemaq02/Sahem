
import 'package:account/API/login_request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      'https://10.0.2.2:5000/api/complaints/general?pageSize=10&pageNumber=2&intDistance=30&userLat=$lat&userLng=$lng'
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

  } else {
    throw Exception(
        'Failed to get complaints. Status code: ${response.statusCode}');
  }
}


// class GeneralComplaint {
//     int intComplaintId;
//     String strFirstName;
//     String strLastName;
//     String? strFirstNameAr;
//     String? strLastNameAr;
//     DateTime dtmDateCreated;
//     String? strAddress;
//     int intTypeId;
//     String? strComplaintTypeEn;
//     String? strComplaintTypeAr;
//     String strComment;
//     int intStatusId;
//     String? strStatusEn;
//     String strStatusAr;
//     int intVoted;
//     int intVotersCount;
//     LatLng latLng;
//     List<LstMedia> lstMedia;
//     bool blnIsOnWatchList;
//     bool blnIsVerified;

//     GeneralComplaint({
//         required this.intComplaintId,
//         required this.strFirstName,
//         required this.strLastName,
//         required this.strFirstNameAr,
//         required this.strLastNameAr,
//         required this.dtmDateCreated,
//         required this.strAddress,
//         required this.intTypeId,
//         required this.strComplaintTypeEn,
//         required this.strComplaintTypeAr,
//         required this.strComment,
//         required this.intStatusId,
//         required this.strStatusEn,
//         required this.strStatusAr,
//         required this.intVoted,
//         required this.intVotersCount,
//         required this.latLng,
//         required this.lstMedia,
//         required this.blnIsOnWatchList,
//         required this.blnIsVerified,
//     });
// factory GeneralComplaint.fromJson(Map<String, dynamic> json) {
//     return GeneralComplaint(
//       intComplaintId: json['intComplaintId'],
//       strFirstName: json['strFirstName'],
//       strLastName: json['strLastName'],
//       strFirstNameAr: json['strFirstNameAr'],
//       strLastNameAr: json['strLastNameAr'],
//       dtmDateCreated: DateTime.parse(json['dtmDateCreated']),
//       strAddress: json['strAddress'],
//       intTypeId: json['intTypeId'],
//       strComplaintTypeEn: json['strComplaintTypeEn'],
//       strComplaintTypeAr: json['strComplaintTypeAr'],
//       strComment: json['strComment'],
//       intStatusId: json['intStatusId'],
//       strStatusEn: json['strStatusEn'],
//       strStatusAr: json['strStatusAr'],
//       intVoted: json['intVoted'],
//       intVotersCount: json['intVotersCount'],
//       latLng:json['LatLng'],
//       lstMedia: json['lstMedia'], 
//       blnIsOnWatchList: json['blnIsOnWatchList'],
//       blnIsVerified: json['blnIsVerified'],
//     );
//   }

// }

// class LatLng {
//     double decLat;
//     double decLng;

//     LatLng({
//         required this.decLat,
//         required this.decLng,
//     });

// }

// class LstMedia {
//     String data;
//     bool isVideo;

//     LstMedia({
//         required this.data,
//         required this.isVideo,
//     });

// }

