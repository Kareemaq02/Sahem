import 'dart:math';
import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ComplaintData {
  ComplaintData(this.region, this.complaints, this.tasks);
  final String region;
  final int complaints;
  final int tasks;
}

class ComplaintTaskChart extends StatelessWidget {
  const ComplaintTaskChart({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    List<ComplaintData> data = [
      ComplaintData(
          "راس العين", Random().nextInt(60) + 88, Random().nextInt(44) + 78),
      ComplaintData(
          "جبل النزهة", Random().nextInt(60) + 88, Random().nextInt(44) + 78),
      ComplaintData(
          "شفا بدران", Random().nextInt(60) + 88, Random().nextInt(44) + 78),
      ComplaintData(
          "المقابلين", Random().nextInt(60) + 88, Random().nextInt(44) + 78),
      ComplaintData(
          "الياسمين", Random().nextInt(60) + 88, Random().nextInt(44) + 78),
      ComplaintData(
          "ماركا", Random().nextInt(60) + 88, Random().nextInt(44) + 78),
      ComplaintData(
          "جبل الحسين", Random().nextInt(60) + 88, Random().nextInt(44) + 78),
      ComplaintData(
          "ابو نصير", Random().nextInt(60) + 88, Random().nextInt(44) + 78),
    ];

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
              StackedColumnSeries<ComplaintData, String>(
                dataSource: data,
                xValueMapper: (ComplaintData count, _) => count.region,
                yValueMapper: (ComplaintData count, _) => count.complaints,
                name: 'البلاغات',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                color: const Color.fromARGB(255, 14, 166, 226),
                width: 0.35,
                legendIconType: LegendIconType.diamond,
              ),
              StackedColumnSeries<ComplaintData, String>(
                dataSource: data,
                xValueMapper: (ComplaintData count, _) => count.region,
                yValueMapper: (ComplaintData count, _) => count.complaints,
                name: 'المهام',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                color: const Color.fromARGB(255, 226, 205, 14),
                width: 0.35,
                legendIconType: LegendIconType.diamond,
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
