import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:account/Widgets/HelperWidgets/TitleText.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';

class ComplaintsAdd extends StatelessWidget {
  final double height;
  final double width;
  final List<int> lstComplaintIds;
  final Function() onPressed;
  final Function(int) onComplaintRemove;

  const ComplaintsAdd(
      {super.key,
      required this.height,
      required this.width,
      required this.lstComplaintIds,
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
                      child: SingleChildScrollView(
                        clipBehavior: Clip.antiAlias,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 0.75,
                              width: width * 0.1,
                            ),
                            ...List.generate(
                              lstComplaintIds.length,
                              (index) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.01),
                                // Ticket Container
                                child: Material(
                                  child: InkWell(
                                    onLongPress: () {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.delete),
                                                title: const TitleText(
                                                    text: "حذف"),
                                                onTap: () {
                                                  onComplaintRemove(
                                                      lstComplaintIds[index]);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: height * 0.75,
                                      width: width * 0.15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                75, 0, 0, 0),
                                            blurRadius: 5,
                                            offset: Offset(0, height * 0.05),
                                          )
                                        ],
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppColor.line, width: 1),
                                      ),
                                      child: Ink(
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: height * 0.1),
                                            child: TitleText(
                                              text: lstComplaintIds[index]
                                                  .toString(),
                                              fontSize: height * 0.33,
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
                        ),
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
