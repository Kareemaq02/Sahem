import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';

class RateData {
  RateData(this.region, this.rate);
  final String region;
  final double rate;
}

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock API
    final List<ChartData> chartData = [];
    final List<ChartData> chartData2 = [];
    final DateTime startDate = DateTime(2023, 1, 1);
    final DateTime endDate = DateTime(2023, 3, 31);

    final Random random = Random();
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      final int randomValue = random.nextInt(67) + 71;
      final int randomValue2 = random.nextInt(67) + 71;
      chartData.add(ChartData(currentDate, randomValue));
      chartData2.add(ChartData(currentDate, randomValue2));
      currentDate = currentDate.add(const Duration(days: 7));
    }

    return SfCartesianChart(
      primaryYAxis: NumericAxis(
        labelFormat: '{value}',
        labelStyle: const TextStyle(
          fontSize: 12,
          color: AppColor.secondary,
        ),
      ),
      primaryXAxis: DateTimeCategoryAxis(
        dateFormat: DateFormat.MMMd(),
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
          dataSource: chartData,
          name: "البلاغات المرسله",
          legendIconType: LegendIconType.diamond,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.count,
          color: Colors.purple,
          // trendlines: <Trendline>[
          //   Trendline(type: TrendlineType.polynomial, color: Colors.blue)
          // ],
        ),
        SplineSeries<ChartData, DateTime>(
          dataSource: chartData2,
          name: "البلاغات المنجزة",
          legendIconType: LegendIconType.diamond,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.count,
          color: Colors.orange,
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
