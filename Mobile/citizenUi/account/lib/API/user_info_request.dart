import 'dart:convert';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';

// ignore_for_file: camel_case_types

//import 'package:account/API/login_request.dart';

class UserInfoModel {
  int? intId;
  String? strUsername;
  String? strFirstName;
  String? strLastName;
  String? strFirstNameAr;
  String? strLastNameAr;
  bool? boolIsVerified;
  bool? boolIsActive;
  bool? boolIsBlacklisted;
  String? strPhoneNumber;
  String? strNationalId;
  String? strNationalIdNumber;
  String? strPassportNumber;
  String? strRegistrationNumber;

  UserInfoModel({
    required this.intId,
    required this.strUsername,
    required this.strFirstName,
    required this.strLastName,
    required this.strFirstNameAr,
    required this.strLastNameAr,
    required this.boolIsVerified,
    required this.boolIsActive,
    required this.boolIsBlacklisted,
    required this.strPhoneNumber,
    required this.strNationalId,
    required this.strNationalIdNumber,
    required this.strPassportNumber,
    required this.strRegistrationNumber,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      intId: json['intId'],
      strUsername: json['strUsername'],
      strFirstName: json['strFirstName'],
      strLastName: json['strLastName'],
      strFirstNameAr: json['strFirstNameAr'],
      strLastNameAr: json['strLastNameAr'],
      boolIsVerified: json['boolIsVerified'],
      boolIsActive: json['boolIsActive'],
      boolIsBlacklisted: json['boolIsBlacklisted'],
      strPhoneNumber: json['strPhoneNumber'],
      strNationalId: json['strNationalId'],
      strNationalIdNumber: json['strNationalIdNumber'],
      strPassportNumber: json['strPassportNumber'],
      strRegistrationNumber: json['strRegistrationNumber'],
    );
  }
}

class getUserInfo {
   final token2 = prefs!.getString('token');
  Future<List<UserInfoModel>> getUserInfoById() async {
    var baseUrl = "${AppUrl.baseURL}/users/info";

    http.Response response = await http
        .get(Uri.parse(baseUrl), headers: {'Authorization': 'Bearer $token2'});

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as Map<String, dynamic>;
      UserInfoModel userInfo = UserInfoModel.fromJson(jsonData);
      return [userInfo];
    } else {
      throw response.statusCode;
    }
  }
}
