import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/VoteWidegts/count.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';
import 'package:account/API/watch_complaint_request.dart';
import 'package:account/Widgets/VoteWidegts/downVote.dart';
import 'package:account/Widgets/VoteWidegts/voteButton.dart';
import 'package:account/Widgets/ComaplaintCard/timeLineWidget.dart';
// ignore_for_file: unused_import


// ignore_for_file: file_names, library_private_types_in_public_api

// ignore_for_file: must_be_immutable


class ComplaintCardPublicForm extends StatefulWidget {
  final String dtmDateCreated;
  final String strComplaintTypeEn;
  final String strComment;
  int intVotersCount;
  final int statusID;
  final String statusAr;
  final String strUserName1;
  final String strUserName2;
  final double lat;
  final double lng;
  final int intComplaintId;
  int isVoted;
  bool? isWatched;
  int i;
  String base64ComplaintPic;

  ComplaintCardPublicForm(
      {super.key,
      required this.base64ComplaintPic,
      required this.dtmDateCreated,
      required this.strComplaintTypeEn,
      required this.strComment,
      required this.intVotersCount,
      required this.statusID,
      required this.statusAr,
      required this.strUserName1,
      required this.strUserName2,
      required this.intComplaintId,
      required this.lat,
      required this.lng,
      required this.isVoted,
      required this.isWatched,
      required this.i});

  @override
  _ComplaintCardsState createState() => _ComplaintCardsState();
}

class _ComplaintCardsState extends State<ComplaintCardPublicForm> {
  @override
  void initState() {
    super.initState();
    fetchAddress();
  }

  WatchComplaint watchReq = WatchComplaint();
  String address = "";
  int watchPressed = 0;

  Future<void> fetchAddress() async {
    address = (await getAddressFromCoordinates(widget.lat, widget.lng))!;
    if (mounted) {
      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.7,
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(0.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 255, 241, 241),
              offset: Offset(0, 0),
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // Card
              Row(
                children: [
                  //status container
                  Container(
                    height: 20,

                    // width: 67,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 223, 222, 222),
                          offset: Offset(0, 0),
                          blurRadius: 2,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        text(
                          widget.statusAr,
                          AppColor.main,
                        ),
                        const Icon(Icons.circle,
                            color: AppColor.main, size: 10),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        "${widget.strUserName1} ${widget.strUserName2}",
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontFamily: 'DroidArabicKufi',
                          fontSize: 11.5,
                          color: AppColor.textTitle,
                          fontWeight: FontWeight.w700,
                        ),
                        softWrap: false,
                      ),
                    ],
                  ),
                ],
              ),
              //time

              Text(formatTimeDifference(widget.dtmDateCreated),
                  style: const TextStyle(
                    color: Color(0xff92a5c6),
                    fontSize: 10,
                    fontFamily: 'DroidArabicKufi',
                  )),


              //description
              Expanded(
                flex: 1,
                child: ReadMoreText(
                  widget.strComment != ""
                      ? widget.strComment
                      : "أرجو من الجهات المختصة النظر في هذه الشكوى و نأمل توفير السلامة والراحة للجميع والعمل على تحسين حالة الطرق في المنطقة. شكراً لتفهمكم وتعاونكم.",
                  trimLines: 2,
                  colorClickableText: Colors.grey,
                  textDirection: TextDirection.rtl,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'اقرأ المزيد',
                  trimExpandedText: 'الرجوع',
                  moreStyle: const TextStyle(
                    fontFamily: 'DroidArabicKufi',
                    fontWeight: FontWeight.w300,
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                  style: const TextStyle(
                      fontFamily: 'DroidArabicKufi',
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      color: AppColor.textBlue),
                ),
              ),

            
              SizedBox(
                height: screenHeight * 0.48,
                child: Image.memory(
                  base64Decode(widget.base64ComplaintPic),
                  fit: BoxFit.cover,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // address
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: Text(
                      address,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontFamily: 'DroidArabicKufi',
                        fontSize: 10,
                        color: AppColor.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      textWidthBasis: TextWidthBasis.values[0],
                    ),
                  ),

                  //const SizedBox(width:,),
                  const Spacer(),
                  VoteWidget(
                    initialCount: widget.intVotersCount,
                    complaintID: widget.intComplaintId,
                    isVoted: widget.isVoted,
                    onVoteChanged: (voteInfo) {
                      setState(() {
                        widget.intVotersCount = voteInfo.count;
                        widget.isVoted = voteInfo.isLiked ? 1 : 0;
                      });
                    },
                  ),
                  CountWidget(initialCount: widget.intVotersCount),
                  DownVote(
                    initialCount: widget.intVotersCount,
                    complaintID: widget.intComplaintId,
                    isVoted: widget.isVoted,
                    onVoteChanged: (voteInfo) {
                      setState(() {
                        widget.intVotersCount = voteInfo.count;
                        widget.isVoted = voteInfo.isLiked ? -1 : 0;
                      });
                    },
                  ),
                  Container(
                    width: 1,
                    color: Colors.grey,
                    height: 25,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (widget.isWatched == false) {
                        await watchReq.watchRequest(widget.intComplaintId);
                        setState(() {
                          widget.isWatched = true;
                        });
                      } else {
                        if (widget.isWatched == true) {
                          await watchReq.unwatchRequest(widget.intComplaintId);
                          setState(() {
                            widget.isWatched = false;
                          });
                        }
                      }
                    },
                    icon: Icon(
                      Icons.bookmark_outline_sharp,
                      size: 29,
                      color: widget.isWatched == true || watchPressed == 1
                          ? AppColor.main
                          : Colors.grey,
                    ),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> getAddressFromCoordinates(double lat, double lng) async {
  try {
    final List<Placemark> placemarks = await placemarkFromCoordinates(
      lat,
      lng,
      localeIdentifier: 'ar',
    );

    if (placemarks.isNotEmpty) {
      final Placemark placemark = placemarks[0];
      final String? address = placemark.street;
      return address;
    } else {
      return '';
    }
  } catch (e) {
    return '$e';
  }
}

String formatTimeDifference(String apiDateString) {
  final apiDate = DateTime.parse(apiDateString);
  final currentDate = DateTime.now();
  final timeDifference = currentDate.difference(apiDate);

  if (timeDifference.inDays >= 365) {
    final years = (timeDifference.inDays / 365).floor();
    return 'قبل $years سنة${years == 1 ? "" : "ات"}';
  } else if (timeDifference.inDays >= 30) {
    final months = (timeDifference.inDays / 30).floor();
    return 'قبل ${months == 1 ? "شهر" : (months == 2 ? "شهرين" : "$months أشهر")}';
  } else if (timeDifference.inDays == 1) {
    return 'قبل يوم';
  } else if (timeDifference.inDays >= 2 && timeDifference.inDays != 12) {
    return 'قبل ${timeDifference.inDays} أيام';
  } else if (timeDifference.inDays == 1) {
    return 'قبل يوم';
  } else if (timeDifference.inDays == 2) {
    return 'قبل يومين';
  } else if (timeDifference.inDays >= 11) {
    return 'قبل ${timeDifference.inDays} يوم';
  } else if (timeDifference.inHours >= 3) {
    return 'قبل ${timeDifference.inHours} ساعات';
  } else if (timeDifference.inHours == 1) {
    return 'قبل ساعة';
  } else if (timeDifference.inHours > 1) {
    return 'قبل ${timeDifference.inHours} ساعات';
  } else if (timeDifference.inMinutes > 1) {
    return 'قبل ${timeDifference.inMinutes} دقائق';
  } else if (timeDifference.inMinutes == 1) {
    return 'قبل دقيقة';
  } else {
    return 'قبل ${timeDifference.inSeconds} ثواني';
  }
}

