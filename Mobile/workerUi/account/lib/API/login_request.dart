import 'dart:io';
import 'dart:convert';
import 'package:account/Repository/urls.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:account/Screens/Home/MainMenuAdmin.dart';
import 'package:account/Screens/Home/MainMenuWorker.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: use_build_context_synchronously

// ignore_for_file: avoid_print

var userToken = "";

class UserData {
  UserData({
    required this.intId,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.userType,
  });

  int intId;
  String userName;
  String firstName;
  String lastName;
  String phoneNumber;
  String userType;
}

UserData getUserData() {
  List<String> parts = userToken.split('.');
  String payload = parts[1];
  String decodedPayload =
      utf8.decode(base64Url.decode(base64Url.normalize(payload)));

  Map<String, dynamic> payloadData = json.decode(decodedPayload);

  var user = UserData(
    intId: int.tryParse(payloadData['id'])!,
    userName: payloadData['username'],
    firstName: payloadData['firstName'],
    lastName: payloadData['lastName'],
    phoneNumber: payloadData['phoneNumber'],
    userType: payloadData['userType'],
  );

  return user;
}

bool userIsAdmin() {
  return getUserData().userType.contains("admin");
}

Widget getCondtionalWidget(
    Widget adminPage, Widget leaderPage, Widget workerPage) {
  switch (getUserData().userType) {
    case "admin":
      return adminPage;
    case "worker":
      return workerPage;
    case "teamleader":
      return leaderPage;
    default:
      return const XDLogin();
  }
}

class UserLogin {
  Future<int> login(
      String username, String password, BuildContext context) async {
    print(username);
    print(password);
    try {
      HttpOverrides.global = MyHttpOverrides();
      Response response = await post(
        Uri.parse('${AppUrl.baseURL}account/login/'),
        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "strLogin": username,
          "strPassword": password,
        }),
      );

      if (response.statusCode == 200) {
        userToken = jsonDecode(response.body).toString();

        var userType = getUserData().userType;
        if (userType == "user") {
          showPasswordDialog(context, response);
          return response.statusCode;
        }

        print(userToken);
        print('Login successful');

        // Save the token in shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', userToken);

        Widget menu = getCondtionalWidget(
          const MainMenuAdmin(),
          const MainMenuWorker(),
          const MainMenuWorker(),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => menu,
          ),
        );

        // final userData = await fetchUserData(token2);
        // print(userData);
        return response.statusCode;
      } else if (response.statusCode == 401) {
        showPasswordDialog(context, response);
        return response.statusCode;
      } else {
        print('Login failed');
        return response.statusCode;
      }
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  void showPasswordDialog(BuildContext context, Response response) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          response.body == "\"User doesn't exist.\""
              ? "User does't exist "
              : "Password is not correct",
          style: const TextStyle(color: Colors.blue),
        ),
        content: const Text("please enter again"),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

// Fetching user data using the token
// Future<Map<String, dynamic>> fetchUserData(String token) async {
//   try {
//     final response = await http.get(
//       Uri.parse('https://10.0.2.2:5000/api/account/userdata/'),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       return data;
//     } else {
//       throw Exception('Failed to fetch user data');
//     }
//   } catch (e) {
//     throw Exception(e.toString());
//   }
// }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
