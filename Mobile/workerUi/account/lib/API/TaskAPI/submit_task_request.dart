import 'dart:io';
import 'package:account/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
import 'package:account/Screens/Results/SuccessPage.dart';

String leadertoken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMiLCJ1c2VybmFtZSI6ImxlYWRlciIsImZpcnN0TmFtZSI6ImxlYWRlciIsImxhc3ROYW1lIjoibGVhZGVyIiwicGhvbmVOdW1iZXIiOiIwNzg4ODgxMjg4IiwidXNlclR5cGUiOiJ0ZWFtbGVhZGVyIiwibmJmIjoxNjk1NjM2OTM0LCJleHAiOjE2OTgyMjg5MzQsImlhdCI6MTY5NTYzNjkzNH0.hEWtiSKdYSYmpP7Pqkz0ym-cyN4Thw5lubeqWy1MDRo';

class SubmitTask {
  final userToken = prefs!.getString('token');
  Future<void> submitTask(
    context,
    String intTaskId,
    List<MediaFile> lstMedia,
    String strComment,
    List<WorkerRating> lstWorkersRatings,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppUrl.baseURL}tasks/submit/$intTaskId"),
      );

      request.headers.addAll({"Authorization": "Bearer $leadertoken"});
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['strComment'] = strComment;

      for (var index = 0; index < lstWorkersRatings.length; index++) {
        var workerRating = lstWorkersRatings[index];
        request.fields['lstWorkersRatings[$index].intWorkerId'] =
            workerRating.intWorkerId.toString();
        request.fields['lstWorkersRatings[$index].decRating'] =
            workerRating.decRating.toString();
      }

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

      final responseJson = await response.stream.bytesToString();

      print(userToken);
      print(response.reasonPhrase);
      print(response.statusCode);
      print(response.request);
      if (response.statusCode != 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SuccessPage(
                    text: ' تم تسليم العمل بنجاح',
                  )),
        );
        print(responseJson);
        print('Task submited successfully.');
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

class WorkerRating {
  int intWorkerId;
  double decRating;

  WorkerRating(this.intWorkerId, this.decRating);
}
