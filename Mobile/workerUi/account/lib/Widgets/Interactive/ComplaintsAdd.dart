import 'package:account/API/ComplaintsAPI/View_Complaints_Request.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';

class ComplaintsAdd extends StatelessWidget {
  final double height;
  final double width;
  final List<ComplaintModel> lstComplaints;
  final Function() onPressed;
  final Function(ComplaintModel) onComplaintRemove;

  const ComplaintsAdd(
      {super.key,
      required this.height,
      required this.width,
      required this.lstComplaints,
      required this.onPressed,
      required this.onComplaintRemove});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StyledButton(text: "إضافه", fontSize: 14, onPressed: onPressed),
            SizedBox(
              height: height,
              width: width * 0.6,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: height,
                      width: width * 0.6,
                      child: lstComplaints.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: height * 0.75,
                                    width: width * 0.1,
                                  ),
                                  ...List.generate(
                                    lstComplaints.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.01),
                                      // Ticket Container
                                      child: Container(
                                        height: height * 0.75,
                                        width: width * 0.15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                  75, 0, 0, 0),
                                              blurRadius: 5,
                                              offset: Offset(0, height * 0.05),
                                            )
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Material(
                                            child: InkWell(
                                              onTap: () {
                                                showModalBottomSheet<void>(
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                                  ),
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          leading: TitleText(
                                                            text: lstComplaints[
                                                                    index]
                                                                .intComplaintId
                                                                .toString(),
                                                          ),
                                                          title: const TitleText(
                                                              text:
                                                                  "بلاغ رقم:"),
                                                        ),
                                                        ListTile(
                                                          leading: TitleText(
                                                            text: lstComplaints[
                                                                    index]
                                                                .dtmDateCreated
                                                                .toString(),
                                                          ),
                                                          title: const TitleText(
                                                              text:
                                                                  "تاريخ الإضافه:"),
                                                        ),
                                                        ListTile(
                                                          leading: TitleText(
                                                            text: lstComplaints[
                                                                    index]
                                                                .strComplaintTypeAr
                                                                .toString(),
                                                          ),
                                                          title: const TitleText(
                                                              text:
                                                                  "نوع البلاغ:"),
                                                        ),
                                                        ListTile(
                                                          leading: TitleText(
                                                            text:
                                                                "${lstComplaints[index].latlng.lng} ,${lstComplaints[index].latlng.lat}",
                                                          ),
                                                          title: const TitleText(
                                                              text:
                                                                  "موقع البلاغ:"),
                                                        ),
                                                        ListTile(
                                                          leading: TitleText(
                                                            text:
                                                                "${(lstComplaints[index].decPriority * 100).toStringAsFixed(1)}%",
                                                          ),
                                                          title: const TitleText(
                                                              text:
                                                                  "الأولويه:"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              onLongPress: () {
                                                showModalBottomSheet<void>(
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                                  ),
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          leading: TitleText(
                                                            text: lstComplaints[
                                                                    index]
                                                                .intComplaintId
                                                                .toString(),
                                                          ),
                                                          title: const TitleText(
                                                              text:
                                                                  "بلاغ رقم:"),
                                                        ),
                                                        ListTile(
                                                          leading: const Icon(
                                                            Icons.delete,
                                                            color:
                                                                AppColor.main,
                                                          ),
                                                          title:
                                                              const TitleText(
                                                                  text: "حذف"),
                                                          onTap: () {
                                                            onComplaintRemove(
                                                                lstComplaints[
                                                                    index]);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Ink(
                                                height: height * 0.75,
                                                width: width * 0.15,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          const Color.fromARGB(
                                                              75, 0, 0, 0),
                                                      blurRadius: 5,
                                                      offset: Offset(
                                                          0, height * 0.05),
                                                    )
                                                  ],
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: AppColor.line,
                                                      width: 1),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: height * 0.1,
                                                        right: width * 0.01,
                                                        left: width * 0.01),
                                                    child: TitleText(
                                                      text: lstComplaints[index]
                                                          .intComplaintId
                                                          .toString(),
                                                      fontSize: height * 0.25,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.75,
                                    width: width * 0.1,
                                  ),
                                ],
                              ))
                          : const Center(
                              child: TitleText(text: "لم يتم إضافة بلاغ"),
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IgnorePointer(
                      child: Container(
                        height: height,
                        width: width * 0.2,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white,
                              Color.fromARGB(0, 255, 255, 255)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IgnorePointer(
                      child: Container(
                        height: height,
                        width: width * 0.2,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.white,
                              Color.fromARGB(0, 255, 255, 255)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const TitleText(text: "البلاغات:")
          ],
        ),
      ),
    );
  }
}
