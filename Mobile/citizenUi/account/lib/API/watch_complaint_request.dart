


import 'dart:convert';

import 'package:account/API/login_request.dart';
import 'package:http/http.dart' as http;


class WatchComplaint{
  
 Future<int?>watchRequest(var complaintId) async {
  try {
   
    http.Response response = await http.post(
      Uri.parse("https://10.0.2.2:5000/api/complaints/addToWatchlist/$complaintId"),
      headers: <String, String>{
        "Content-type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token2'
      },
     
    
    );
  print("watched");
    print(response.body);
    print(response.statusCode);
    print(response.reasonPhrase);
    print(response.headers);
     print(complaintId);

    if (response.statusCode == 200) {
      token2 = jsonDecode(response.body);
      print(token2);
      print('watched successful');
   
      return response.statusCode;
    } 
    else {
      print('watch failed');
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
    return 0;
    
  }

}

}