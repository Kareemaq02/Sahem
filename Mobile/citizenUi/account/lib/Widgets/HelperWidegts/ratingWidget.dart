import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/rate_completed_complaint.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:account/Widgets/HelperWidegts/popupBotton.dart';
// ignore_for_file: library_private_types_in_public_api

// ignore_for_file: file_names

class RatingWidget1 extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final int complaintId;
  const RatingWidget1({super.key, required this.complaintId});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget1> {
  final RateComplaint _rate = RateComplaint();
  double _rating = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var dialogHeight = screenHeight * 0.3;
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
            height: dialogHeight,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "تقييم البلاغ المنجز",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColor.main,
                    fontFamily: 'DroidArabicKufi',
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: AppColor.line,
                  ),
                  onRatingUpdate: (rating) {
                    rating = rating;
                    // print(_rating = rating);
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BottonContainerPopup(
                        "إلغاء ",
                        AppColor.main,
                        Colors.white,
                        context,
                        true,
                        "",
                        () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      BottonContainerPopup(
                        "إرسال",
                        AppColor.main,
                        Colors.white,
                        context,
                        true,
                        "",
                        () {
                          _rate.rateRequest(widget.complaintId, _rating);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
