import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/complaint_requests.dart';

List<Status> status = [
  Status(1, ' قيد الانتظار'),
  Status(2, 'موافق عليه'),
  Status(3, 'مجدول'),
  Status(4, 'موافق عليه'),
  Status(5, 'قيد العمل'),
  Status(6, 'انتظار التقييم'),
  Status(7, 'منجز'),
];

class Status {
  int id;
  String name;

  Status(this.id, this.name);
}

Widget timeLineWidget(statusID) {
  getUserComplaint a = getUserComplaint();
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        indicatorPosition: 1,
        color: AppColor.line,
        direction: Axis.horizontal,
      ),
      builder: TimelineTileBuilder.connectedFromStyle(
        contentsAlign: ContentsAlign.alternating,
        connectionDirection: ConnectionDirection.before,
        connectorStyleBuilder: (context, index) {
          return (index == 0)
              ? ConnectorStyle.solidLine
              : ConnectorStyle.dashedLine;
        },
        contentsBuilder: (context, index) {
          return FutureBuilder<List<dynamic>>(
            future: a.fetchStatus(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(': ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<dynamic> statusData = snapshot.data!;
                if (index < statusData.length) {
                  TextStyle textStyle = const TextStyle(
                    fontSize: 7.9,
                    color: AppColor.main,
                    fontFamily: 'DroidArabicKufi',
                  );

                  // Check if index is greater than 1, and apply grey color.
                  if (index > 0) {
                    textStyle = textStyle.copyWith(color: Colors.grey);
                  }

                  return Text(
                    status[index].name.toString(),
                    //statusData[index]['strName'],
                    style: textStyle,
                  );
                } else {
                  return const Text('No data for this index');
                }
              } else {
                return Container();
              }
            },
          );
        },
        indicatorStyleBuilder: (context, index) => IndicatorStyle.outlined,
        itemExtent: 73.0,
        itemCount: 7,
      ),
    ),
  );
}
