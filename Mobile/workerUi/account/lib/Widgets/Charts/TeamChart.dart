import 'dart:math';
import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PercentData {
  PercentData(this.region, this.approved, this.inProgress, this.completed);
  final String region;
  final int approved;
  final int inProgress;
  final int completed;
}

class TeamChart extends StatelessWidget {
  const TeamChart({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Random random = Random();
    var regions = [
      "راس العين",
      "جبل النزهة",
      "شفا بدران",
      "المقابلين",
      "الياسمين",
      "ماركا",
      "جبل الحسين",
      "ابو نصير",
    ];
    List<PercentData> data = [];
    for (var entry in regions) {
      double approvedPercent = random.nextDouble() * 100;
      double inProgressPercent = random.nextDouble() * (100 - approvedPercent);
      double completedPercent = 100 - approvedPercent - inProgressPercent;
      approvedPercent = (approvedPercent * 10.0).roundToDouble() / 10.0;
      inProgressPercent = (inProgressPercent * 10.0).roundToDouble() / 10.0;
      completedPercent = (completedPercent * 10.0).roundToDouble() / 10.0;

      var percent = PercentData(entry, approvedPercent.toInt(),
          inProgressPercent.toInt(), completedPercent.toInt());
      data.add(percent);
    }

    return SizedBox(
      width: data.length * 0.20 * screenWidth,
      child: Column(
        children: [
          SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enablePanning: true,
              zoomMode: ZoomMode.xy,
            ),
            primaryXAxis: CategoryAxis(
              isInversed: true,
              visibleMinimum: 3,
              labelStyle: const TextStyle(
                fontSize: 10,
                color: AppColor.secondary,
                fontFamily: 'DroidArabicKufi',
              ),
              title: AxisTitle(
                text: '',
                textStyle: const TextStyle(
                  fontSize: 12,
                  color: AppColor.textTitle,
                  fontFamily: 'DroidArabicKufi',
                ),
              ),
            ),
            primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(
                fontSize: 10,
                color: AppColor.secondary,
                fontWeight: FontWeight.bold,
                fontFamily: 'DroidArabicKufi',
              ),
              title: AxisTitle(
                text: 'العدد',
                textStyle: const TextStyle(
                  fontSize: 12,
                  color: AppColor.textTitle,
                  fontFamily: 'DroidArabicKufi',
                ),
              ),
            ),
            legend: const Legend(
              height: "0",
              toggleSeriesVisibility: false,
              position: LegendPosition.bottom,
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColor.textTitle,
                fontFamily: 'DroidArabicKufi',
              ),
              isVisible: true,
            ),
            series: <ChartSeries>[
              StackedColumnSeries<PercentData, String>(
                dataSource: data,
                xValueMapper: (PercentData count, _) => count.region,
                yValueMapper: (PercentData count, _) => count.approved,
                name: 'مجدول',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                color: const Color.fromARGB(255, 28, 183, 245),
                width: 0.35,
                legendIconType: LegendIconType.diamond,
                dataLabelMapper: (data, index) => "${data.approved}",
              ),
              StackedColumnSeries<PercentData, String>(
                dataSource: data,
                xValueMapper: (PercentData count, _) => count.region,
                yValueMapper: (PercentData count, _) => count.inProgress,
                name: 'غير مكتمل',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                color: const Color.fromARGB(255, 219, 198, 2),
                width: 0.35,
                legendIconType: LegendIconType.diamond,
                dataLabelMapper: (data, index) => "${data.inProgress}",
              ),
              StackedColumnSeries<PercentData, String>(
                dataSource: data,
                xValueMapper: (PercentData count, _) => count.region,
                yValueMapper: (PercentData count, _) => count.completed,
                name: 'مكتمل',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                color: const Color.fromARGB(255, 0, 238, 59),
                width: 0.35,
                legendIconType: LegendIconType.diamond,
                dataLabelMapper: (data, index) => "${data.completed}",
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
