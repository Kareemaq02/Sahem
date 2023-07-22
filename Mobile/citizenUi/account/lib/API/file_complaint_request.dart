// ignore_for_file: avoid_print, unused_local_variablimport 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'login_request.dart';

class Complaint {
  Future<void> fileComplaint(
    int intTypeId,
    int intPrivacyId,
    List<MediaFile> lstMedia,

    String strComment,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://10.0.2.2:5000/api/complaints'),
      );
      print(token2);

      // Add the request headers
      request.headers.addAll({"Authorization": "Bearer $token2"});
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add the request fields
      request.fields['intTypeId'] = intTypeId.toString();
      request.fields['intPrivacyId'] = intPrivacyId.toString();
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

 
   request.fields['lstMedia[$index].decLat'] = mediaFile.decLat.toString();
   request.fields['lstMedia[$index].decLng'] = mediaFile.decLng.toString();
   request.fields['lstMedia[$index].blnIsVideo'] =
   mediaFile.blnIsVideo.toString();
}

      
      final response = await request.send();

     
      final responseJson = await response.stream.bytesToString();

      

      if (response.statusCode == 200) {
        print(responseJson);
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
  final File file;
  final double decLat;
  final double decLng;
  final bool blnIsVideo;

  MediaFile(this.file, this.decLat, this.decLng, this.blnIsVideo);
}
