import 'dart:io';
import 'package:account/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
import 'package:account/Screens/Results/SuccessPage.dart';

// ignore_for_file: avoid_print




class Complaint {
final token2 = prefs!.getString('token');


  Future<void> fileComplaint(
    context,
    int intTypeId,
    int intPrivacyId,
    List<MediaFile> lstMedia,
    int intRegionId,
    String strComment,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppUrl.baseURL}/complaints'),
      );
      print(token2);

      // Add the request headers
      request.headers.addAll({"Authorization": "Bearer $token2"});
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add the request fields
      request.fields['intTypeId'] = intTypeId.toString();
      request.fields['intPrivacyId'] = intPrivacyId.toString();
      request.fields['strComment'] = strComment;
      request.fields['intRegionId'] = intRegionId.toString();

      // Add the files
      for (var index = 0; index < lstMedia.length; index++) {
        var mediaFile = lstMedia[index];
        var stream = http.ByteStream(mediaFile.file.openRead());
        var length = await mediaFile.file.length();
        var multipartFile = http.MultipartFile(
          'lstMedia[$index].fileMedia',
          stream,
          length,
          filename: mediaFile.file.path.split('/').last,
        );
        request.files.add(multipartFile);

        request.fields['lstMedia[$index].decLat'] = mediaFile.decLat.toString();
        request.fields['lstMedia[$index].decLng'] = mediaFile.decLng.toString();
        request.fields['lstMedia[$index].blnIsVideo'] =
            mediaFile.blnIsVideo.toString();
      }

      final response = await request.send();

      //final responseJson = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("file as new");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const SuccessPage(text: "تم إرسال البلاغ بنجاح",)),
        );
        //print(responseJson);
        print('Complaint assigned successfully.');
      } else {
        print('failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  
}

class MediaFile {
  File file;
  double? decLat;
  double? decLng;
  bool blnIsVideo;

  MediaFile(this.file, this.decLat, this.decLng, this.blnIsVideo);
}


Future<dynamic> fileAsSimilar(var complaintId, context) async {
  final token2 = prefs!.getString('token');
  try {
    http.Response response = await http.post(
      Uri.parse(
          "${AppUrl.baseURL}/complaints/upvote/addToWatchList/similar/$complaintId"),
      headers: <String, String>{
        "Content-type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token2'
      },
    );

    if (response.statusCode == 200) {
      print("file as similar");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SuccessPage(text: 'تم إرسال البلاغ بنجاح',)),
      );

      print('successful');

      return response.statusCode;
    } else {
      print(' failed');
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
    return 0;
  }
}
