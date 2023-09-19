import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore_for_file: file_names


class RateData {
  RateData(this.region, this.rate);
  final String region;
  final double rate;
}

class PerformanceChart extends StatelessWidget {
  final List<ChartData> complaintData;
  final List<ChartData> taskData;
  final DateTime startDate;
  final DateTime endDate;

  const PerformanceChart({
    super.key,
    required this.complaintData,
    required this.taskData,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryYAxis: NumericAxis(
        labelFormat: '{value}',
        labelStyle: const TextStyle(
          fontSize: 12,
          color: AppColor.secondary,
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
      primaryXAxis: DateTimeCategoryAxis(
        dateFormat: DateFormat.yMMMd(),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: AppColor.secondary,
        ),
      ),
      legend: const Legend(
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
        SplineSeries<ChartData, DateTime>(
          dataSource: complaintData,
          name: "البلاغات المرسله",
          legendIconType: LegendIconType.diamond,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.count,
          color: Colors.purple,
          // trendlines: <Trendline>[
          //   Trendline(
          //     type: TrendlineType.polynomial,
          //     color: Colors.blue,
          //   )
          // ],
        ),
        SplineSeries<ChartData, DateTime>(
          dataSource: taskData,
          name: "البلاغات المنجزة",
          legendIconType: LegendIconType.diamond,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.count,
          color: Colors.orange,
          // trendlines: <Trendline>[
          //   Trendline(
          //     type: TrendlineType.polynomial,
          //     color: Colors.blue,
          //   )
          // ],
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.date, this.count);
  final DateTime date;
  final int count;
}
