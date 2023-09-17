import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/complaint_requests.dart';
// ignore_for_file: file_names


List<Status> status1 = [

  Status(1, ' قيد الانتظار'),
  Status(2, 'مرفوض'),
  Status(3, 'مجدول'),
  Status(4, 'قيد العمل'),
  Status(5, 'انتظار التقييم'),
  Status(6, 'منجز'),
  Status(7, 'بلاغ معاد'),
];

class Status {
  int id;
  String name;

  Status(this.id, this.name);
}

Widget timeLineWidget(int statusID) {
  getUserComplaint a = getUserComplaint();
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        indicatorPosition: 0,
        color: AppColor.line,
        direction: Axis.horizontal,
      ),
      builder: TimelineTileBuilder.connectedFromStyle(
        contentsAlign: ContentsAlign.alternating,
        connectionDirection: ConnectionDirection.before,
        connectorStyleBuilder: (context, index) {
          if (index == 0) {
            ConnectorStyle.solidLine;
          }
          if (statusID > 1) {
            return (index <= statusID - 1)
                ? ConnectorStyle.solidLine
                : ConnectorStyle.dashedLine;
          } else {
            return (index <= statusID)
                ? ConnectorStyle.solidLine
                : ConnectorStyle.dashedLine;
          }
        },
        contentsBuilder: (context, index) {
          return FutureBuilder<List<dynamic>>(
            future: a.fetchStatus(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(': ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<dynamic> statusData = snapshot.data!;
                if (index < status1.length && index != 1) {
                  TextStyle textStyle = const TextStyle(
                    fontSize: 8.9,
                    fontFamily: 'DroidArabicKufi',
                  );
                  
                  if (statusID > 1) {
                    if (index <= statusID - 1) {
                      textStyle = textStyle.copyWith(color: AppColor.main);
                    } else {
                      textStyle = textStyle.copyWith(color: Colors.grey);
                    }
                  } else {
                    if (index <= statusID) {
                      textStyle = textStyle.copyWith(color: AppColor.main);
                    } else {
                      textStyle = textStyle.copyWith(color: Colors.grey);
                    }
                  }

                  return Text(
                    status1[index].name.toString(),
                    style: textStyle,
                  );
                }
                if (index == 1) {
                  return Container();
                } else {
                  return const Text('No data for this index');
                }
              } else {
                return Container();
              }
            },
          );
        },
        indicatorStyleBuilder: (context, index) {
          if (index == 1) {
            return IndicatorStyle.transparent;
          }
          return (index <= statusID - 1)
              ? IndicatorStyle.dot
              : IndicatorStyle.outlined;
        },
        itemExtent: 73.0,
        itemCount: 6,
      ),
    ),
  );
}
