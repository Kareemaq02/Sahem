import 'dart:io';
import 'package:account/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:account/Widgets/Popup/confirmPage.dart';
// ignore_for_file: avoid_print, unused_local_variablimport 'dart:convert';

class SubmitTask {
    final userToken =prefs!.getString('token');
  Future<void> submitTask(context, String intTaskId, List<MediaFile> lstMedia,
      String strComment) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("https://10.0.2.2:5000/api/tasks/submit/$intTaskId"),
      );

      // Add the request headers
      request.headers.addAll({"Authorization": "Bearer $userToken"});
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add the request fields
      request.fields['strComment'] = strComment;

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

        request.fields['lstMedia[$index].blnIsVideo'] =
            mediaFile.blnIsVideo.toString();
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
          MaterialPageRoute(builder: (context) => const confirm()),
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
  final File file;
  final bool blnIsVideo = false;

  MediaFile(this.file, blnIsVideo);
}
