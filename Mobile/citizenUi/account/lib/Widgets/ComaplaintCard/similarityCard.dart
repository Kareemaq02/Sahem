import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/file_complaint_request.dart';
import 'package:account/Widgets/HelperWidegts/popupBotton.dart';
import 'package:account/Screens/File%20complaint/confirmPopup.dart';

class SimilarityCard extends StatefulWidget {
  final int compplaintID;
  final image;
  final int typeID;
  final String typeName;
  final String address;
  final String comment;
  final media;

  SimilarityCard({
    required this.compplaintID,
    required this.image,
    required this.typeID,
    required this.typeName,
    required this.address,
    required this.comment,
    required this.media,
  });

  @override
  _SimilarityCardState createState() => _SimilarityCardState();
}

class _SimilarityCardState extends State<SimilarityCard> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
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
                child: Text(
                  "هل تقصد هذا البلاغ ؟",
                  style: TextStyle(
                    fontFamily: 'DroidArabicKufi',
                    fontSize: 13,
                    color: AppColor.textBlue,
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.3,
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.memory(
                  widget.image,
                ),
              ),
              RowInfo("نوع البلاغ", widget.typeName),
              RowInfo("موقع البلاغ", widget.address),
              const Divider(
                color: AppColor.line,
                thickness: 1.5,
              ),
              SizedBox(height: screenHeight * 0.0),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: BottonContainerPopup(
                      "لا",
                      AppColor.main,
                      Colors.white,
                      context,
                      true,
                      "",
                      () {
                        fileObj.fileComplaint(
                          context,
                          widget.typeID,
                          1,
                          widget.media,
                          1,
                          widget.comment,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BottonContainerPopup(
                      "نعم",
                      AppColor.main,
                      Colors.white,
                      context,
                      true,
                      "",
                      () {
                        fileAsSimilar(widget.compplaintID, context);
                      },
                    ),
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
  }
}
