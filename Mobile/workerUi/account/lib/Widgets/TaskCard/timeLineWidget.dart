import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:account/Repository/color.dart';
// ignore_for_file: file_names


List<Status> statusList = [
  Status(1, 'غير مفعل'),
  Status(2, 'قيد العمل'),
  Status(3, 'انتظار التقييم'),
  Status(4, 'فشل '),
  Status(5, 'غير مكتمل'),
  Status(6, 'منجز'),
];

class Status {
  int id;
  String name;

  Status(this.id, this.name);
}
Widget timeLineWidget(statusID) {

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        indicatorPosition: 0,
        color: statusID == 4 || statusID == 5 ? Colors.grey : AppColor.line,
        direction: Axis.horizontal,
      ),
      builder: TimelineTileBuilder.connectedFromStyle(
        contentsAlign: ContentsAlign.alternating,
        connectionDirection: ConnectionDirection.before,
        connectorStyleBuilder: (context, index) {
          return (index <= statusID - 1)
              ? ConnectorStyle.solidLine
              : ConnectorStyle.dashedLine;
        },
        contentsBuilder: (context, index) {
          // Use the stored data if available
          if (index < statusList.length) {
            TextStyle textStyle = const TextStyle(
              fontSize: 8.9,
              fontFamily: 'DroidArabicKufi',
            );
            if (statusID == 4 || statusID == 5) {
              textStyle = textStyle.copyWith(color: Colors.grey);
            } else if (index <= statusID - 1) {
              textStyle = textStyle.copyWith(color: AppColor.main);
            } else {
              textStyle = textStyle.copyWith(color: Colors.grey);
            }

            return Text(
              index != 3
                  ? statusList[index].name.toString()
                  : statusList[5].name.toString(),
              style: textStyle,
            );
          } else {
            return Container();
          }
        },
        indicatorStyleBuilder: (context, index) {
          return (index <= statusID - 1)
              ? IndicatorStyle.dot
              : IndicatorStyle.outlined;
        },
        itemExtent: 90,
        itemCount: 4,
      ),
    ),
  );
}
