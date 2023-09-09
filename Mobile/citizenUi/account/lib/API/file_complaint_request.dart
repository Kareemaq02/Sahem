import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'login_request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/Widgets/MapWidgets/mapPageView.dart';
import 'package:account/Widgets/HelperWidegts/popupBotton.dart';
import 'package:account/Screens/File%20complaint/confirmPage.dart';
import 'package:account/Screens/File%20complaint/confirmPopup.dart';

// ignore_for_file: avoid_print, unused_local_variablimport 'dart:convert';

class Complaint {
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

      final responseJson = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => confirm()),
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

  Future<dynamic> checkSimilar(
      context,
      int intTypeId,
      int intPrivacyId,
      List<MediaFile> lstMedia,
      int intRegionId,
      String strComment,
      address,
      type) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://10.0.2.2:5000/api/complaints/similarComplaintCheck'),
      );

      // Add the request headers
      request.headers.addAll({"Authorization": "Bearer $token2"});
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add the request fields
      request.fields['intTypeId'] = "15";
      request.fields['intPrivacyId'] = "2";
      // request.fields['intTypeId'] = intTypeId.toString();
      // request.fields['intPrivacyId'] = intPrivacyId.toString();
      request.fields['strComment'] = strComment;
      //request.fields['intRegionId'] = intRegionId.toString();

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

        request.fields['lstMedia[$index].decLat'] = "31.963975";
        request.fields['lstMedia[$index].decLng'] = "35.924515";
        // request.fields['lstMedia[$index].decLat'] = mediaFile.decLat.toString();
        // request.fields['lstMedia[$index].decLng'] = mediaFile.decLng.toString();
        request.fields['lstMedia[$index].blnIsVideo'] =
            mediaFile.blnIsVideo.toString();
      }

      final response = await request.send();

      final responseJson = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseJson);
        final bool blnHasSimilar = jsonResponse['blnHasSimilar'];
        var similarComplaintLstMedia = jsonResponse['similarComplaintLstMedia'];
        var dataValue = similarComplaintLstMedia[0]['data'];

        String base64String = dataValue;
        Uint8List bytes = base64Decode(base64String);

        if (blnHasSimilar == true) {
          print(type);
          print(address);
          SimilarityCard(
              context, bytes, intTypeId, type, address, strComment, lstMedia);
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
}

class MediaFile {
  File file;
  double? decLat;
  double? decLng;
  bool blnIsVideo;

  MediaFile(this.file, this.decLat, this.decLng, this.blnIsVideo);
}

SimilarityCard(context, image, typeID, typeName, adress, comment, media) async {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //title:
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          content: SizedBox(
            height: screenHeight * 0.60,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text("هل تقصد هذا البلاغ ؟",
                        // textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontFamily: 'DroidArabicKufi',
                            fontSize: 13,
                            color: AppColor.textBlue)),
                  ),
                  Container(
                    height: screenHeight * 0.3,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                        //color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Image.memory(
                      image,
                    ),
                  ),
                  RowInfo("نوع البلاغ", typeName),
                  RowInfo("موقع البلاغ", adress),
                  const Divider(
                    color: AppColor.line,
                    thickness: 1.5,
                  ),
                  SizedBox(height: screenHeight * 0.0),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: BottonContainerPopup("لا", AppColor.main,
                            Colors.white, context, true, null, () {
                          //Navigator.of(context).pop();
                          fileObj.fileComplaint(
                              context, typeID, 1, media, 1, comment);
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: BottonContainerPopup("نعم", AppColor.main,
                            Colors.white, context, true, null, () {
                          Navigator.of(context).pop();
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
