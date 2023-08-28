// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:account/API/login_request.dart';
import 'package:account/Widgets/countProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';



class VoteComplaint{
  
 Future<dynamic>sendVoteRequest(var complaintId,context) async {
   final countProvider = Provider.of<CountProvider>(context, listen: false);
  try {
   
    http.Response response = await http.post(
      Uri.parse("https://10.0.2.2:5000/api/complaints/vote/$complaintId"),
      headers: <String, String>{
        "Content-type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token2'
      },
     
    
    );
  print("Voteeeeeeeeeeeeeeeeeeeeeee");
    // print(response.body);
    // print(response.statusCode);
    // print(response.reasonPhrase);
    // print(response.headers);
    //  print(complaintId);

    if (response.statusCode == 200) {
      countProvider.updateCount(countProvider.count + 1);
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

 Future<dynamic>removeVoteRequest(var complaintId,context) async {
   final countProvider = Provider.of<CountProvider>(context, listen: false);
  try {
   
    http.Response response = await http.post(
      Uri.parse("https://10.0.2.2:5000/api/complaints/voteremove/$complaintId"),
      headers: <String, String>{
        "Content-type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token2'
      },
     
    
    );
  print("Voteee removed ");
    // print(response.body);
    // print(response.statusCode);
    // print(response.reasonPhrase);
    // print(response.headers);
    //  print(complaintId);

    if (response.statusCode == 200) {
       countProvider.updateCount(countProvider.count - 1);
      print('Voted removed successful');


      return response.statusCode;
    } 
    else {
      print('Vote removed failed');
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
    return 0;
    
  }

}

Future<dynamic>DownVoteRequest(var complaintId,context) async {
     final countProvider = Provider.of<CountProvider>(context, listen: false);
  try {
   
    http.Response response = await http.post(
      Uri.parse("https://10.0.2.2:5000/api/complaints/votedown/$complaintId"),
      headers: <String, String>{
        "Content-type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token2'
      },
     
    
    );
    print(" voted downed");


    if (response.statusCode == 200) {
       countProvider.updateCount(countProvider.count -1);
      print('Voted downed successful');
    

      return response.statusCode;
    } 
    else {
      print('Vote downed failed');
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
    return 0;
    
  }

}

}
