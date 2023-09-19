import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/TaskAPI/view_tasks_request.dart';
// ignore_for_file: file_names


List<Status> status2 = [
  Status(0, 'غير مفعل', "14:32:58 202-3-12مارس "),
  Status(1, 'قيد العمل', "--:--:--"),
  Status(2, 'انتظار التقييم', "--:--:--"),
  Status(3, 'منجز', "--:--:--"),
];

class Status {
  int id;
  String name;
  String time;

  Status(this.id, this.name, this.time);
}

Widget timeLineVertical() {
  WorkerTask a = WorkerTask();
  return FixedTimeline.tileBuilder(
    theme: TimelineThemeData(
      indicatorPosition: 1,
      color: AppColor.line,
      direction: Axis.vertical,
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasError) {
              return Text(': ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<dynamic> statusData = snapshot.data!;
              if (index < statusData.length) {
                TextStyle textStyle = const TextStyle(
                  fontSize: 11.9,
                  color: AppColor.main,
                  fontFamily: 'DroidArabicKufi',
                );

                // Check if index is greater than 1, and apply grey color.
                if (index > 0) {
                  textStyle = textStyle.copyWith(color: Colors.grey);
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    '${status2[index].name}\n${status2[index].time}',
                    //statusData[index]['strName'],
                    style: textStyle,
                  ),
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
      //itemExtent: 73.0,
      itemExtent: 107.0,
      itemCount: 4,
    ),
  );
}
