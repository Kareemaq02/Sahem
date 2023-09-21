import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/complaint_requests.dart';
// ignore_for_file: file_names


List<Status> status22 = [
  Status(1, ' قيد الانتظار', ""),
  Status(2, ' مرفوض', "--:--:--"),
  Status(3, 'موافق عليه', "--:--:--"),
  Status(4, 'مجدول', "--:--:--"),
  Status(5, ' مرفوض', "--:--:--"),
  Status(6, 'موافق عليه', "--:--:--"),
  Status(7, 'قيد العمل', "--:--:--"),
  Status(8, 'انتظار التقييم', "--:--:--"),
  Status(9, 'منجز', "--:--:--"),
  Status(10, 'اعادة توجيه', "--:--:--"),
];

class Status {
  int id;
  String name;
  String time;

  Status(this.id, this.name, this.time);
}

getUserComplaint a = getUserComplaint();
Widget timeLineVertical(int complaintId) {
  return FutureBuilder<List<ComaplintSatus>>(
    future: a.fetchComaplintStatus(complaintId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        List<ComaplintSatus> statusData = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FixedTimeline.tileBuilder(
            theme: TimelineThemeData(
              indicatorPosition: 1,
              color: AppColor.line,
              direction: Axis.vertical,
            ),
            builder: TimelineTileBuilder.connectedFromStyle(
              contentsAlign: ContentsAlign.alternating,
              connectionDirection: ConnectionDirection.before,
              connectorStyleBuilder: (context, index) {
                return (index <= statusData.length)
                    ? ConnectorStyle.solidLine
                    : ConnectorStyle.dashedLine;
              },
              contentsBuilder: (context, index) {
                if (index < status22.length) {
                  Status status = status22[index];
                  TextStyle textStyle = const TextStyle(
                    fontSize: 11.9,
                    fontFamily: 'DroidArabicKufi',
                  );

                  if (statusData.isNotEmpty &&
                      index == statusData.last.intComplaintStatusId - 1) {
                    // Completed status, use API data
                    ComaplintSatus apiStatus = statusData.last;
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        '${apiStatus.strStatusNameAr}\n${apiStatus.dtmTrans.toString().substring(0, 10)}',
                        style: textStyle.copyWith(color: AppColor.main),
                      ),
                    );
                  } else {
                    // Incomplete status, use placeholder data
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        '${status.name}\n--:--:--',
                        style: textStyle.copyWith(color: Colors.grey),
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
              indicatorStyleBuilder: (context, index) {
                return (index < statusData.length)
                    ? (index <= statusData.last.intComplaintStatusId)
                        ? IndicatorStyle.dot
                        : IndicatorStyle.outlined
                    : IndicatorStyle.outlined;
              },
              itemExtent: 73.0,
              itemCount: status22.length, // Render based on status2's length
            ),
          ),
        );
      } else {
        return const Text('No data available.');
      }
    },
  );
}
