import 'dart:convert';
import 'dart:typed_data';
import 'login_request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/urls.dart';
import 'package:account/API/file_complaint_request.dart';
import 'package:account/Screens/File%20complaint/confirmPage.dart';
import 'package:account/Widgets/ComaplaintCard/similarityCard.dart';

Future<dynamic> checkSimilar(
    BuildContext context,
    int intTypeId,
    int intPrivacyId,
    List<MediaFile> lstMedia,
    int intRegionId,
    String strComment,
    String address,
    String type) async {

  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppUrl.baseURL}/complaints/similarComplaintCheck'),
    );

    // Add the request headers
    request.headers.addAll({"Authorization": "Bearer $token2"});
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add the request fields
    // request.fields['intTypeId'] = "1";
    // request.fields['intPrivacyId'] = "2";
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

      // request.fields['lstMedia[$index].decLat'] = "31.970416";
      // request.fields['lstMedia[$index].decLng'] = "35.881530";
      request.fields['lstMedia[$index].decLat'] = mediaFile.decLat.toString();
      request.fields['lstMedia[$index].decLng'] = mediaFile.decLng.toString();
      request.fields['lstMedia[$index].blnIsVideo'] =
          mediaFile.blnIsVideo.toString();
    }

    final response = await request.send();

    final responseJson = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(responseJson);
      final bool blnHasSimilar = jsonResponse['blnHasSimilar'];

      print(blnHasSimilar);

      if (blnHasSimilar == true) {
        var similarComplaintLstMedia = jsonResponse['similarComplaintLstMedia'];
        var dataValue = similarComplaintLstMedia[0]['data'];
        String base64String = dataValue;
        Uint8List bytes = base64Decode(base64String);

        await showDialog(
            context: context,
            builder: (context) {
              return SimilarityCard(
                compplaintID: jsonResponse['intId'],
                image: bytes,
                typeID: intTypeId,
                typeName: type,
                address: address,
                comment: strComment,
                media: lstMedia,
              );
            });
        print('There are similar complaints.');
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context1) => confirm()),
        );
      }

      print('Complaint assigned successfully.');
    } else {
      print('failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}
