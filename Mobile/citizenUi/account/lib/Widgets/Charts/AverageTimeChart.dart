import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TimeData {
  TimeData(this.region, this.time);
  final String region;
  final Duration time;
}

class AverageTimeChart extends StatelessWidget {
  const AverageTimeChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    final data = <TimeData>[
      TimeData("راس العين", const Duration(hours: 16)),
      TimeData("جبل النزهة", const Duration(hours: 26)),
      TimeData("شفا بدران", const Duration(hours: 49)),
      TimeData("المقابلين", const Duration(hours: 24)),
      TimeData("الياسمين", const Duration(hours: 23)),
      TimeData("ماركا", const Duration(hours: 32)),
      TimeData("جبل الحسين", const Duration(hours: 21)),
      TimeData("ابو نصير", const Duration(hours: 66)),
    ];

    return SizedBox(
      width: data.length * 0.20 * screenWidth,
      child: SfCartesianChart(
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
            text: 'الساعات',
            textStyle: const TextStyle(
              fontSize: 12,
              color: AppColor.textTitle,
              fontFamily: 'DroidArabicKufi',
            ),
          ),
        ),
        series: <ChartSeries>[
          ColumnSeries<TimeData, String>(
            dataSource: data,
            xValueMapper: (TimeData times, _) => times.region,
            yValueMapper: (TimeData times, _) => times.time.inHours,
            name: 'Times',
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            color: const Color.fromARGB(255, 7, 204, 194),
            width: 0.35,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
