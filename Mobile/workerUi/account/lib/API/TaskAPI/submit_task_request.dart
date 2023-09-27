import 'dart:io';
import 'package:account/API/TaskAPI/get_activated_task.dart';
import 'package:account/API/login_request.dart';
import 'package:account/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
import 'package:account/Screens/Results/SuccessPage.dart';

class SubmitTask {
  final userToken = prefs!.getString('token');
  Future<void> submitTask(
    context,
    String intTaskId,
    List<MediaFile> lstMedia,
    String strComment,
    List<WorkerRating> lstWorkersRatings,
  ) async {
    lstWorkersRatings
        .removeWhere((element) => element.intWorkerId == getUserData().intId);
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppUrl.baseURL}tasks/submit/$intTaskId"),
      );

      request.headers.addAll({"Authorization": "Bearer $userToken"});
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
        request.fields['lstMedia[$index].decLatLng.decLat'] =
            mediaFile.decLatLng!.decLat.toString();
        request.fields['lstMedia[$index].decLatLng.decLng'] =
            mediaFile.decLatLng!.decLng.toString();

        request.fields['lstMedia[$index].blnIsVideo'] =
            mediaFile.blnIsVideo.toString();
        request.fields['lstMedia[$index].intComplaintId'] =
            mediaFile.intComplaintId.toString();
      }

      final response = await request.send();

      final responseJson = await response.stream.bytesToString();

      print(userToken);
      print(response.reasonPhrase);
      print(response.statusCode);
      print(response.request);
      if (response.statusCode == 200) {
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
  LatLng? decLatLng;
  bool blnIsVideo;
  int intComplaintId;

  MediaFile(this.file, this.decLatLng, this.blnIsVideo, this.intComplaintId);
}

class WorkerRating {
  int intWorkerId;
  double decRating;

  WorkerRating(this.intWorkerId, this.decRating);
}
